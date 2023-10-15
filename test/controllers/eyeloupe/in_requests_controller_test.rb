# frozen_string_literal: true

require "test_helper"

module Eyeloupe
  class InRequestsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @in_request = eyeloupe_in_requests(:one)
    end

    test "should get index" do
      get in_requests_url
      assert_response :success
    end

    test "should get show" do
      get in_request_url(@in_request)
      assert_response :success
    end
  end
end