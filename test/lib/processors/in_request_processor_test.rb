# frozen_string_literal: true

require "test_helper"

class InRequestProcessorTest < ActiveSupport::TestCase
  def setup
    @out_request_processor = Eyeloupe::Processors::InRequest.instance
    @env = {
      "REQUEST_METHOD" => "GET",
      "PATH_INFO" => "/",
      "HTTP_HOST" => "localhost",
      "HTTP_USER_AGENT" => "Rails Testing",
      "rack.input" => StringIO.new
    }
    @request = ActionDispatch::Request.new(@env)
  end

  test "should initialize in request processor" do
    assert_not_nil @out_request_processor
  end

  test "should start timer and subscribe" do
    @out_request_processor.start_timer
    assert_not_nil @out_request_processor.started_at
    assert @out_request_processor.started_at.is_a?(Time)
    assert @out_request_processor.subs.size == 1
    assert @out_request_processor.subs[0].is_a?(ActiveSupport::Notifications::Fanout::Subscribers::Timed)
  end

  test "should unsubscribe after process" do
    @out_request_processor.start_timer
    @out_request_processor.init(@request, @env, 200, {}, "", nil)
    assert_not_nil @out_request_processor.process
    assert @out_request_processor.subs.size == 0
  end

  test "should have correct total duration without timings" do
    @out_request_processor.start_timer
    @out_request_processor.init(@request, @env, 200, {}, "", nil)
    assert_not_equal 0, @out_request_processor.send(:get_total_duration)
  end

  test "should have correct total duration with timings" do
    @out_request_processor.start_timer
    @out_request_processor.init(@request, @env, 200, {}, "", nil)
    @out_request_processor.timings = {
      controller_time: 1,
    }
    assert_equal 1, @out_request_processor.send(:get_total_duration)
  end

  test "should get correct response" do
    @out_request_processor.start_timer
    @env['HTTP_ACCEPT'] = "text/html"
    @request = ActionDispatch::Request.new(@env)

    @out_request_processor.init(@request, @env, 200, {}, "", nil)

    assert_equal "HTML content", @out_request_processor.send(:get_response)
  end

  test "should get correct response for body response" do
    @out_request_processor.start_timer
    @request.format = nil
    response = ActionDispatch::Response.new(200, {}, "test")
    @out_request_processor.init(@request, @env, 200, {}, response, nil)
    assert_equal "test", @out_request_processor.send(:get_response)
  end

  test "should get correct response for non body response" do
    @out_request_processor.start_timer
    @request.format = nil
    @out_request_processor.init(@request, @env, 200, {}, "test2", nil)
    assert_equal "test2", @out_request_processor.send(:get_response)
  end

  test "should get correct controller with no controller class" do
    @out_request_processor.start_timer
    @out_request_processor.init(@request, @env, 200, {}, "", nil)
    assert_nil @out_request_processor.send(:get_controller)
  end

  test "should get correct controller with controller class" do
    @out_request_processor.start_timer
    @request.path_parameters = { controller: "eyeloupe/in_requests", action: "index" }
    @out_request_processor.init(@request, @env, 200, {}, "", nil)
    assert_equal "Eyeloupe::InRequestsController#index", @out_request_processor.send(:get_controller)
  end
end
