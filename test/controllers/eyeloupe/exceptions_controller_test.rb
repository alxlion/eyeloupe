require "test_helper"

module Eyeloupe
  class ExceptionsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @exception = eyeloupe_exceptions(:one)
    end

    test "should get index" do
      get exceptions_url
      assert_response :success
    end

    test "should show exception" do
      get exception_url(@exception)
      assert_response :success
    end
  end
end
