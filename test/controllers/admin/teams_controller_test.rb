require "test_helper"

class Admin::TeamsControllerTest < ActionDispatch::IntegrationTest
  test "super admin can list teams" do
    sign_in(users(:super_admin))

    get admin_teams_path

    assert_response :success
  end

  test "super admin can delete a team" do
    team = teams(:basic)
    sign_in(users(:super_admin))

    assert_difference -> { Team.where(id: team.id).count }, -1 do
      delete admin_team_path(team)
    end

    assert_response :see_other
    assert_redirected_to admin_teams_path
  end

  test "a non super admin can not delete a team through the admin area" do
    team = teams(:basic)
    sign_in(users(:owner))

    delete admin_team_path(team)

    assert Team.exists?(team.id)
    assert_redirected_to dashboard_path
  end
end
