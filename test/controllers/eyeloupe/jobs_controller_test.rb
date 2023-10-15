require "test_helper"

module Eyeloupe
  class JobsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @job = eyeloupe_jobs(:one)
    end

    test "should get index" do
      get jobs_url
      assert_response :success
    end

    test "should get show" do
      get jobs_url(@job)
      assert_response :success
    end
  end
end
