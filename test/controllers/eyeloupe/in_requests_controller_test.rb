# frozen_string_literal: true

require "test_helper"

module Eyeloupe
  class InRequestsControllerTest < ActionDispatch::IntegrationTest
    fixtures "eyeloupe/in_requests"

    test "should get index" do
      get eyeloupe.in_requests_url
      assert_response :success
    end

    test "should get show" do
      get eyeloupe.in_request_url(eyeloupe_in_requests(:one))
      assert_response :success
    end
  end
end