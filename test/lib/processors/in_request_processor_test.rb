# frozen_string_literal: true

require "test_helper"

class InRequestProcessorTest < ActiveSupport::TestCase
  def setup
    @processor = Eyeloupe::Processors::InRequest.instance
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
    assert_not_nil @processor
  end

  test "should start timer and subscribe" do
    @processor.start_timer
    assert_not_nil @processor.started_at
    assert @processor.started_at.is_a?(Time)
    assert @processor.subs.size == 1
    assert @processor.subs[0].is_a?(ActiveSupport::Notifications::Fanout::Subscribers::Timed)
  end

  test "should unsubscribe after process" do
    @processor.start_timer
    @processor.init(@request, @env, 200, {}, "")
    assert_not_nil @processor.process
    assert @processor.subs.size == 0
  end

  test "should have correct total duration without timings" do
    @processor.start_timer
    @processor.init(@request, @env, 200, {}, "")
    assert_not_equal 0, @processor.send(:get_total_duration)
  end

  test "should have correct total duration with timings" do
    @processor.start_timer
    @processor.init(@request, @env, 200, {}, "")
    @processor.timings = {
      controller_time: 1,
    }
    assert_equal 1, @processor.send(:get_total_duration)
  end

  test "should get correct response" do
    @processor.start_timer
    @env['HTTP_ACCEPT'] = "text/html"
    @request = ActionDispatch::Request.new(@env)

    @processor.init(@request, @env, 200, {}, "")

    assert_equal "HTML content", @processor.send(:get_response)
  end

  test "should get correct response for body response" do
    @processor.start_timer
    @request.format = nil
    response = ActionDispatch::Response.new(200, {}, "test")
    @processor.init(@request, @env, 200, {}, response)
    assert_equal "test", @processor.send(:get_response)
  end

  test "should get correct response for non body response" do
    @processor.start_timer
    @request.format = nil
    @processor.init(@request, @env, 200, {}, "test2")
    assert_equal "test2", @processor.send(:get_response)
  end

  test "should get correct controller with no controller class" do
    @processor.start_timer
    @processor.init(@request, @env, 200, {}, "")
    assert_nil @processor.send(:get_controller)
  end

  test "should get correct controller with controller class" do
    @processor.start_timer
    @request.path_parameters = { controller: "eyeloupe/in_requests", action: "index" }
    @processor.init(@request, @env, 200, {}, "")
    assert_equal "Eyeloupe::InRequestsController#index", @processor.send(:get_controller)
  end
end
