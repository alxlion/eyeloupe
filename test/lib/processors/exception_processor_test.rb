# frozen_string_literal: true

require "test_helper"

class ExceptionProcessorTest < ActiveSupport::TestCase
  def setup
    @exception_processor = Eyeloupe::Processors::Exception.instance
    @env = {
      "REQUEST_METHOD" => "GET",
      "PATH_INFO" => "/",
      "HTTP_HOST" => "localhost",
      "HTTP_USER_AGENT" => "Rails Testing",
      "rack.input" => StringIO.new
    }
    @exception = NameError.new("Test Exception")
    @request = ActionDispatch::Request.new(@env)
    @sample_file_name = 'file.rb'
    File.write(@sample_file_name, "puts (\"hello world\")\ncontinue")

    @full_file_name = 'full.rb'
    File.write(@full_file_name, "puts (\"hello world1\")\nputs (\"hello world2\")\nputs (\"hello world3\")\nputs (\"hello world4\")\nputs (\"hello world5\")\nputs (\"hello world6\")\nputs (\"hello world7\")\nputs (\"hello world8\")\nputs (\"hello world9\")\nputs (\"hello world10\")\nputs (\"hello world11\")\nputs (\"hello world12\")\nputs (\"hello world13\")\nputs (\"hello world14\")\nputs (\"hello world15\")\n")
  end

  def teardown
    File.delete(@sample_file_name)
    File.delete(@full_file_name)
  end

  test "should initialize in request processor" do
    assert_not_nil @exception_processor
  end

  test "should read file and return empty array" do
    assert_equal [], @exception_processor.send(:read_file, ["unknown.rb:1"])
  end

  test "should read file and return source code" do
    assert_equal ["puts (\"hello world\")\n", "continue"], @exception_processor.send(:read_file, ["file.rb:1"])
  end

  test "should read file and return scoped source code" do
    assert_equal ["puts (\"hello world6\")\n", "puts (\"hello world7\")\n", "puts (\"hello world8\")\n", "puts (\"hello world9\")\n", "puts (\"hello world10\")\n", "puts (\"hello world11\")\n", "puts (\"hello world12\")\n", "puts (\"hello world13\")\n", "puts (\"hello world14\")\n", "puts (\"hello world15\")\n"], @exception_processor.send(:read_file, ["full.rb:10"])
  end

  test "should update count if already exist" do
    ex = @exception_processor.send(:create_or_update_exception, "Exception", @sample_file_name, 1, ["file.rb:1"], "message", "full message")
    assert_not_nil ex
    assert_equal 1, ex.count

    ex = @exception_processor.send(:create_or_update_exception, "Exception", @sample_file_name, 1, ["file.rb:1"], "message", "full message")

    assert_equal 2, ex.count
  end

  test "should return exception" do
    assert_not_nil @exception_processor.process(@env, @exception)
  end
end
