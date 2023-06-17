# frozen_string_literal: true

require "test_helper"

class OutRequestProcessorTest < ActiveSupport::TestCase
  def setup
    @out_request_processor = Eyeloupe::Processors::OutRequest.instance
    @request = Net::HTTP::Get.new('/')
  end

  test "should initialize out request processor" do
    assert_not_nil @out_request_processor
  end

  test "should init" do
    @out_request_processor.init(@request, "")
    assert_not_nil @out_request_processor.started_at
    assert_not_nil @out_request_processor.request
    assert_not_nil @out_request_processor.body
  end

  test "should process" do
    @out_request_processor.init(@request, "")
    http = Net::HTTP.new('example.com', nil)
    response = http.request(@request)
    res = @out_request_processor.process(response, nil)
    assert_not_nil res
  end

  test "should get headers with request" do
    headers = @out_request_processor.send(:get_headers, @request)
    assert_not_nil headers
    assert headers.is_a?(Hash)
  end

  test "should get headers with response" do
    http = Net::HTTP.new('example.com', nil)
    response = http.request(@request)
    headers = @out_request_processor.send(:get_headers, response)
    assert_not_nil headers
    assert headers.is_a?(Hash)
  end
end
