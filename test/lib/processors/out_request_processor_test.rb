# frozen_string_literal: true

require "test_helper"

class OutRequestProcessorTest < ActiveSupport::TestCase
  def setup
    @processor = Eyeloupe::Processors::OutRequest.instance
    @request = Net::HTTP::Get.new('/')
  end

  test "should initialize out request processor" do
    assert_not_nil @processor
  end

  test "should init" do
    @processor.init(@request, "")
    assert_not_nil @processor.started_at
    assert_not_nil @processor.request
    assert_not_nil @processor.body
  end

  test "should process" do
    @processor.init(@request, "")
    http = Net::HTTP.new('example.com', nil)
    response = http.request(@request)
    res = @processor.process(response)
    assert_not_nil res
  end

  test "should get headers with request" do
    headers = @processor.send(:get_headers, @request)
    assert_not_nil headers
    assert headers.is_a?(Hash)
  end

  test "should get headers with response" do
    http = Net::HTTP.new('example.com', nil)
    response = http.request(@request)
    headers = @processor.send(:get_headers, response)
    assert_not_nil headers
    assert headers.is_a?(Hash)
  end
end
