require "test_helper"

class DataControllerTest < ActionDispatch::IntegrationTest
  correct_headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "X-API-Key": "the-correct-key"
    }
  test "returns a 406 not acceptable unless request is json" do
    team = teams(:basic)

    get team_data_path(team)
    assert_response :not_acceptable
  end

  test "returns a 400 bad request without key" do
    team = teams(:basic)

    get team_data_path(team), headers: { "Accept": "application/json", "Content-Type": "application/json" }
    assert_response :bad_request
  end

  test "returns a 400 bad request with incorrect key" do
    team = teams(:with_api_key)

    get team_data_path(team), headers: { "Content-Type": "application/json", "Accept": "application/json", "X-API-Key": "this-is-wrong" }
    assert_response :bad_request
  end

  # index

  test "returns a 200 with correct key" do
    team = teams(:with_api_key)

    get team_data_path(team), headers: correct_headers
    assert_response :ok
    data = JSON.parse response.body

    assert_equal 3, data.length
    assert DateTime.parse(data[0]["created_at"]).after? DateTime.parse(data[1]["created_at"])
  end

  test "returns the correct amount per page" do
    team = teams(:with_api_key)

    get(
      team_data_path(team),
        headers: correct_headers,
        params: { per_page: 2 }
    )

    assert_response :ok
    data = JSON.parse response.body

    assert_equal 2, data.length
  end

  test "returns the correct page" do
    team = teams(:with_api_key)

    get(
      team_data_path(team),
        headers: correct_headers,
        params: { per_page: 1, page: 3 }
    )

    assert_response :ok
    data = JSON.parse response.body

    assert_equal 1, data.length
    assert_equal 1, data[0]["content"]["prop"]
  end

  test "returns data with the correct name" do
    team = teams(:with_api_key)

    get(
      team_data_path(team),
        headers: correct_headers,
        params: { name: "Another Data Type" }
    )

    assert_response :ok
    data = JSON.parse response.body

    assert_equal 1, data.length
    assert_equal "Another Data Type", data[0]["name"]
  end

  # names

  test "returns names of all data" do
    team = teams(:with_api_key)

    get(names_team_data_path(team), headers: correct_headers)

    assert_response :ok
    data = JSON.parse response.body

    assert_equal 2, data.length
    assert_equal "Another Data Type", data[0]
    assert_equal "Some Data Type", data[1]
  end

  # create

  test "creates data if all valid" do
    team = teams(:with_api_key)

    params = {
      name: "My Data",
      content: { some_data: 1 }
    }

    post team_data_path(team), headers: correct_headers, params: params.to_json

    assert_response :ok

    json = JSON.parse response.body

    puts json

    assert json["id"].class == String
    assert_equal json["team_id"], team.id
    assert_equal params[:content], json["content"].symbolize_keys
  end


  # create

  test "destroys data if all valid" do
    team = teams(:with_api_key)
    data = data(:data_1)

    delete team_datum_path(team, data.id), headers: correct_headers

    assert_response :no_content
    assert_equal 0, Datum.where(id: data.id).length
  end

  test "doesnt data if not from team" do
    team = teams(:with_api_key)
    data = data(:other_data_4)

    delete team_datum_path(team, data.id), headers: correct_headers

    assert_response :bad_request
    assert_equal 1, Datum.where(id: data.id).length
  end
end
