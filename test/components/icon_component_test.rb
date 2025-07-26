# frozen_string_literal: true

require "test_helper"

class IconComponentTest < ViewComponent::TestCase
  test "inserts classes into component" do
    assert_match(
      "pizza-2 taco tree",
      render_inline(IconComponent.new(icon: :new_tab, classes: "pizza-2 taco tree")).to_html
    )
  end
end
