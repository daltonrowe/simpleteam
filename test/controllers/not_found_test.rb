require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "404 raises an error" do
    assert_raises(ActionController::RoutingError) do
      get "/im/not/here"
    end
  end
end
