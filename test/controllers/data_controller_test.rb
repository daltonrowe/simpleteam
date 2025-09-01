require "test_helper"

class DataControllerTest < ActionDispatch::IntegrationTest
  test "returns a 406 unacceptable unless request is json" do
    team = teams(:basic)

    get team_data_path(team)
    assert_response :not_acceptable
  end

  test "returns a 400 bad request" do
    team = teams(:basic)

    get team_data_path(team), headers: { "Accept": "application/json" }
    assert_response :bad_request
  end

  test "returns a 400 bad request with incorrect key" do
    team = teams(:with_api_key)

    get team_data_path(team), headers: { "Accept": "application/json", "X-API-Key": "this-is-wrong" }
    assert_response :bad_request
  end

  test "returns a 200 with correct key" do
    team = teams(:with_api_key)

    get team_data_path(team), headers: { "Accept": "application/json", "X-API-Key": "the-correct-key" }
    assert_response :ok
  end
end
