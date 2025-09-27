require "test_helper"

class TeamUpdateServiceTest < ActiveSupport::TestCase
  test "should format the new sections" do
    team = teams(:basic)

    TeamUpdateService.new(team, {
      "section_0_name"=>"A",
      "section_0_description"=>"a desc",
      "section_1_name"=>"B",
      "section_1_description"=>"b desc",
      "section_2_name"=>"C",
      "section_2_description"=>""
    }).call

    expected = [
      { "name" => "A", "description" => "a desc" },
      { "name" => "B", "description" => "b desc" },
      { "name" => "C" }
    ]

    assert_equal expected, team.sections
  end

  test "should collect end_of_day from params" do
    team = teams(:basic)

    TeamUpdateService.new(team, {
      "end_of_day(4i)"=>"1",
      "end_of_day(5i)"=>"45",
      "time_zone" => "Central Time (US & Canada)"
    }).call

    assert_equal 6, team.end_of_day.hour
    assert_equal 45, team.end_of_day.min
    assert_equal "UTC", team.end_of_day.time_zone.name
  end

  test "should collect notification_time from params" do
    team = teams(:basic)

    TeamUpdateService.new(team, {
      "notification_time(4i)"=>"13",
      "notification_time(5i)"=>"22"
    }).call

    assert_equal 18, team.notification_time.hour
    assert_equal 22, team.notification_time.min
    assert_equal "UTC", team.notification_time.time_zone.name
  end

  test "should collect metadata attributes from params" do
    team = teams(:basic)

    TeamUpdateService.new(team, {
      "project_management_url"=>"https://example.com/someroute"
    }).call

    assert_equal "https://example.com/someroute", team.project_managementment_url
  end

  test "should overwrite metadata attributes from params" do
    team = teams(:with_metadata)

    TeamUpdateService.new(team, {
      "project_management_url"=>"https://example.com/tacos"
    }).call

    assert_equal "https://example.com/tacos", team.project_managementment_url
  end

  test "should convert empty strings to nil" do
    team = teams(:with_metadata)

    TeamUpdateService.new(team, {
      "project_management_url" => ""
    }).call

    assert_nil team.project_managementment_url
  end

  test "should not overwrite if new metadata not present" do
    team = teams(:with_metadata)

    TeamUpdateService.new(team, {}).call

    assert_equal "https://radshack.com/", team.project_managementment_url
  end

  test "should not overwrite if updates other data" do
    team = teams(:with_metadata)

    TeamUpdateService.new(team, { "data_api_key" => "tacobell" }).call

    assert_equal [
      { "name" => "Yesterday" },
      { "name" => "Today" },
      { "name" => "Links", "description" => "Read anything good?" }
    ], team.sections
    assert_equal "https://radshack.com/", team.project_managementment_url
    assert_equal "tacobell", team.data_api_key
  end
end
