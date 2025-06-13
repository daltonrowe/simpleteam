require "test_helper"

class StatusesControllerTest < ActionDispatch::IntegrationTest
  test "302 when logged out" do
    team = teams(:basic)
    get team_statuses_path(team)

    assert_redirected_to new_session_path
  end

  test "200 when logged in and own team" do
    team = teams(:basic)
    user = users(:owner)

    sign_in(user)

    get team_statuses_path(team)

    assert_response :success
    assert_dom "summary", "Today's Status"
  end

  test "200 when logged in and team member" do
    team = teams(:basic)
    user = users(:member)

    sign_in(user)

    get team_statuses_path(team)

    assert_response :success
    assert_dom "summary", "Today's Status"
  end

  test "draft input present when today's status complete" do
    team = teams(:basic)
    user = users(:member)

    sign_in(user)

    Status.create(user: user, team: team, id: SecureRandom.uuid, sections: basic_status_content)

    get team_statuses_path(team)

    assert_response :success
    assert_dom "summary", "Today's Status"
    assert_dom "summary", "Tomorrow's Status (Draft)"
  end

  test "draft input present contains draft content when present" do
    team = teams(:basic)
    user = users(:member)

    sign_in(user)

    cookies[:draft_status] = [
      { name: "Yesterday", content: [ "hey hey hey" ] }
    ].to_json

    Status.create(user: user, team: team, id: SecureRandom.uuid, sections: basic_status_content)

    get team_statuses_path(team)

    assert_response :success
    assert_dom "summary", "Today's Status"
    assert_dom "summary", "Tomorrow's Status (Draft)"
    assert_dom "textarea", "hey hey hey"
  end
end
