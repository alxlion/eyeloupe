require "test_helper"

module Eyeloupe
  class JobsControllerTest < ActionDispatch::IntegrationTest
    fixtures "eyeloupe/jobs"

    test "should get index" do
      get eyeloupe.jobs_url
      assert_response :success
    end

    test "should get show" do
      get eyeloupe.job_url(eyeloupe_jobs(:one))
      assert_response :success
    end
  end
end
