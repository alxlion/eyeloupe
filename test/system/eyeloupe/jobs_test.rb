require "application_system_test_case"

module Eyeloupe
  class JobsTest < ApplicationSystemTestCase
    setup do
      @job = eyeloupe_jobs(:one)
    end

    test "visiting the index" do
      visit jobs_url
      assert_selector "h1", text: "Jobs"
    end
  end
end
