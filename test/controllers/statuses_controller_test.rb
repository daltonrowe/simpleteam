require "test_helper"

class StatusesControllerTest < ActionDispatch::IntegrationTest
  test "302 when logged out" do
    team = teams(:basic)
    get new_team_status_path(team)

    assert_redirected_to new_session_path
  end

  test "200 when logged in and own team" do
    team = teams(:basic)
    user = users(:owner)

    sign_in(user)

    get new_team_status_path(team)

    assert_response :success
    assert_dom "summary", "Today's Status"
  end

  test "200 when logged in and team member" do
    team = teams(:basic)
    user = users(:member)

    sign_in(user)

    get new_team_status_path(team)

    assert_response :success
    assert_dom "summary", "Today's Status"
  end

  test "creating a status properly formats the content" do
    team = teams(:basic)
    user = users(:member)

    sign_in(user)

    post(team_statuses_path(team), params: basic_status_user_input)

    assert_redirected_to new_team_status_path(team)

    follow_redirect!

    assert_dom "summary", { text: "John Doe", count: 1 }
    assert_dom "details li", { count: 3 }
    assert_dom "li", { text: "I love pizza", count: 1 }
    assert_dom "li", { text: "And taco's", count: 1 }
    assert_dom "li", { text: "oh yes", count: 1 }
  end

  test "draft input present when today's status complete" do
    team = teams(:basic)
    user = users(:member)

    sign_in(user)

    Status.create(user: user, team: team, id: SecureRandom.uuid, sections: basic_status_content)

    get new_team_status_path(team)

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

    get new_team_status_path(team)

    assert_response :success
    assert_dom "summary", "Today's Status"
    assert_dom "summary", "Tomorrow's Status (Draft)"
    assert_dom "textarea", "- hey hey hey"
  end

  test "status history displays most recent status on page 1" do
    team = teams(:basic)
    user = users(:member)

    sign_in(user)

    get team_statuses_path(team)

    assert_response :success
    assert_dom "h1", "My Awesome Team History"
    assert_dom "div", "Statuses from May 18, 2025"
    assert_dom "summary", { text: "John Doe", count: 1 }
    assert_dom "li", "Its May 18"
  end

  test "status history displays statuses by date" do
    team = teams(:basic)
    user = users(:member)
    status = statuses(:status_2)

    sign_in(user)

    get team_statuses_path(team, date: status.created_at)

    assert_response :success
    assert_dom "h1", "My Awesome Team History"
    assert_dom "div", "Statuses from May 11, 2025"
    assert_dom "summary", { text: "John Doe", count: 1 }
    assert_dom "li", "Its May 11"
  end

  test "project management urls are expressed as links" do
    team = teams(:with_metadata)
    user = users(:member)
    status = statuses(:with_ticket)

    sign_in(user)

    get team_statuses_path(team, date: status.created_at)

    assert_response :success
    assert_dom "li", "Working on ST-1234 today"
    assert_dom "a", "ST-1234"
  end

  test "markdown urls are expressed as links" do
    team = teams(:with_metadata)
    user = users(:member)
    status = statuses(:with_md_link)

    sign_in(user)

    get team_statuses_path(team, date: status.created_at)

    assert_response :success
    assert_dom "li", "Working on pizza today"
    assert_dom "a[href='https://pizzahut.com']", "pizza"
  end
end
