# frozen_string_literal: true

require "test_helper"

class InRequestProcessorTest < ActiveSupport::TestCase
  def setup
    @inrequest_processor = Eyeloupe::Processors::InRequest.instance
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
    assert_not_nil @inrequest_processor
  end

  test "should start timer and subscribe" do
    @inrequest_processor.start_timer
    assert_not_nil @inrequest_processor.started_at
    assert @inrequest_processor.started_at.is_a?(Time)
    assert @inrequest_processor.subs.size == 1
    assert @inrequest_processor.subs[0].is_a?(ActiveSupport::Notifications::Fanout::Subscribers::Timed)
  end

  test "should unsubscribe after process" do
    @inrequest_processor.start_timer
    @inrequest_processor.init(@request, @env, 200, {}, "", nil)
    assert_not_nil @inrequest_processor.process
    assert @inrequest_processor.subs.size == 0
  end

  test "should have correct total duration without timings" do
    @inrequest_processor.start_timer
    @inrequest_processor.init(@request, @env, 200, {}, "", nil)
    assert_not_equal 0, @inrequest_processor.send(:get_total_duration)
  end

  test "should have correct total duration with timings" do
    @inrequest_processor.start_timer
    @inrequest_processor.init(@request, @env, 200, {}, "", nil)
    @inrequest_processor.timings = {
      controller_time: 1,
    }
    assert_equal 1, @inrequest_processor.send(:get_total_duration)
  end

  test "should get correct response" do
    @inrequest_processor.start_timer
    @env['HTTP_ACCEPT'] = "text/html"
    @request = ActionDispatch::Request.new(@env)

    @inrequest_processor.init(@request, @env, 200, {}, "", nil)

    assert_equal "HTML content", @inrequest_processor.send(:get_response)
  end

  test "should get correct response for body response" do
    @inrequest_processor.start_timer
    @request.format = nil
    response = ActionDispatch::Response.new(200, {}, "test")
    @inrequest_processor.init(@request, @env, 200, {}, response, nil)
    assert_equal "test", @inrequest_processor.send(:get_response)
  end

  test "should get correct response for non body response" do
    @inrequest_processor.start_timer
    @request.format = nil
    @inrequest_processor.init(@request, @env, 200, {}, "test2", nil)
    assert_equal "test2", @inrequest_processor.send(:get_response)
  end

  test "should get correct controller with no controller class" do
    @inrequest_processor.start_timer
    @inrequest_processor.init(@request, @env, 200, {}, "", nil)
    assert_nil @inrequest_processor.send(:get_controller)
  end

  test "should get correct controller with controller class" do
    @inrequest_processor.start_timer
    @request.path_parameters = { controller: "eyeloupe/in_requests", action: "index" }
    @inrequest_processor.init(@request, @env, 200, {}, "", nil)
    assert_equal "Eyeloupe::InRequestsController#index", @inrequest_processor.send(:get_controller)
  end
end
