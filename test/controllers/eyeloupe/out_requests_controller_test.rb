require "test_helper"

module Eyeloupe
  class OutRequestsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @out_request = eyeloupe_out_requests(:one)
    end

    test "should get index" do
      get out_requests_url
      assert_response :success
    end

    test "should show out_request" do
      get out_request_url(@out_request)
      assert_response :success
    end
  end
end
