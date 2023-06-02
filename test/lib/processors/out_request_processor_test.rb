# frozen_string_literal: true

require "test_helper"

class OutRequestProcessorTest < ActiveSupport::TestCase
  def setup
    @inrequest_processor = Eyeloupe::Processors::OutRequest.instance
    @request = Net::HTTP::Get.new('/')
  end

  test "should initialize out request processor" do
    assert_not_nil @inrequest_processor
  end

  test "should init" do
    @inrequest_processor.init(@request, "")
    assert_not_nil @inrequest_processor.started_at
    assert_not_nil @inrequest_processor.request
    assert_not_nil @inrequest_processor.body
  end

  test "should process" do
    @inrequest_processor.init(@request, "")
    http = Net::HTTP.new('example.com', nil)
    response = http.request(@request)
    res = @inrequest_processor.process(response)
    assert_not_nil res
  end

  test "should get headers with request" do
    headers = @inrequest_processor.send(:get_headers, @request)
    assert_not_nil headers
    assert headers.is_a?(Hash)
  end

  test "should get headers with response" do
    http = Net::HTTP.new('example.com', nil)
    response = http.request(@request)
    headers = @inrequest_processor.send(:get_headers, response)
    assert_not_nil headers
    assert headers.is_a?(Hash)
  end
end
