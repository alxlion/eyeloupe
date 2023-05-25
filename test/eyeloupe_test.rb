require "test_helper"

class EyeloupeTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Eyeloupe::VERSION
  end

  test "it has configuration" do
    assert Eyeloupe.configuration
    assert Eyeloupe.configuration.excluded_paths == %w[assets]
    assert Eyeloupe.configuration.capture
  end
end
