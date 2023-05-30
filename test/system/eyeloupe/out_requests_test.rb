require "application_system_test_case"

module Eyeloupe
  class OutRequestsTest < ApplicationSystemTestCase
    setup do
      @out_request = eyeloupe_out_requests(:one)
    end

    test "visiting the index" do
      visit out_requests_url
      assert_selector "h1", text: "HTTP Client"
    end
  end
end
