require "test_helper"
require "securerandom"

class TeamsControllerTest < ActionDispatch::IntegrationTest
  test "owner sees the name input and delete button on the edit page" do
    team = teams(:basic)
    sign_in(users(:owner))

    get edit_team_path(team)

    assert_response :success
    assert_select "input[name='team[name]']"
    assert_select "form[action='#{team_path(team)}'] input[name='_method'][value='delete']"
  end

  test "owner can rename their team" do
    team = teams(:basic)
    sign_in(users(:owner))

    patch team_path(team), params: { team: { name: "Renamed Team" } }

    assert_equal "Renamed Team", team.reload.name
    assert_response :found
  end

  test "owner can delete their team" do
    team = teams(:basic)
    sign_in(users(:owner))

    assert_difference -> { Team.where(id: team.id).count }, -1 do
      delete team_path(team)
    end

    assert_redirected_to dashboard_path
  end

  test "deleting a team removes its statuses and data" do
    team = teams(:basic)
    Status.create!(id: SecureRandom.uuid, user: users(:owner), team:)
    Datum.create!(id: SecureRandom.uuid, team:, name: "metric")
    sign_in(users(:owner))

    delete team_path(team)

    assert_not Team.exists?(team.id)
    assert_empty Status.where(team_id: team.id)
    assert_empty Datum.where(team_id: team.id)
  end

  test "a member can not delete a team they do not own" do
    team = teams(:basic)
    sign_in(users(:member))

    delete team_path(team)

    assert Team.exists?(team.id)
    assert_redirected_to dashboard_path
  end

  test "a non-member can not delete a team" do
    team = teams(:basic)
    sign_in(users(:rando))

    delete team_path(team)

    assert Team.exists?(team.id)
    assert_redirected_to dashboard_path
  end

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
