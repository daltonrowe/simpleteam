require "test_helper"

class ApplicationHelperTest < ActiveSupport::TestCase
  include ApplicationHelper

  hash = {
    a: 1,
    b: 2,
    c: {
      x: 3,
      y: 4,
      z: {
        e: 5,
        f: 6,
        g: 7
      }
    }
  }
  test "deep_search for top level key" do
    result = deep_search(:a, hash)
    assert result == 1
  end

  test "deep_search for nested key" do
    result = deep_search(:x, hash)
    assert result == 3
  end

  test "deep_search for deeply nested key" do
    result = deep_search(:f, hash)
    assert result == 6
  end

  test "deep_search for missing key" do
    result = deep_search(:t, hash)
    assert result == nil
  end
end
