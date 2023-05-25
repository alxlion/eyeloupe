require "test_helper"

class RequestMiddlewareTest < ActiveSupport::TestCase

  def setup
    @middleware = Eyeloupe::RequestMiddleware.new(nil)
    @env = {
      "REQUEST_METHOD" => "GET",
      "PATH_INFO" => "/",
      "HTTP_HOST" => "localhost",
      "HTTP_USER_AGENT" => "Rails Testing",
      "rack.input" => StringIO.new
    }
  end

  test "should not skip request" do
    @request = ActionDispatch::Request.new(@env)
    assert_not @middleware.send(:skip_request?, @request)
  end

  test "should skip request" do
    @env["PATH_INFO"] = "/assets"
    @request = ActionDispatch::Request.new(@env)
    assert @middleware.send(:skip_request?, @request)
  end

end