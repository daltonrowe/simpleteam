require "test_helper"

class TeamsControllerTest < ActionDispatch::IntegrationTest
  test "can create an api key" do
    team = teams(:basic)
    user = users(:owner)
    sign_in(user)

    post team_api_key_path(team)

    team.reload

    assert_kind_of String, team.data_api_key
    assert_response :found
  end

  test "can not create an api key if member of team" do
    team = teams(:basic)
    user = users(:member)
    sign_in(user)

    post team_api_key_path(team)

    team.reload

    assert_kind_of String, team.data_api_key
    assert_response :found
  end

  test "can not create an api key if not on team" do
    team = teams(:basic)
    user = users(:rando)
    sign_in(user)

    post team_api_key_path(team)

    team.reload

    assert_nil team.data_api_key
    assert_response :found
  end
end
