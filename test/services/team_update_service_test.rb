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

    assert_equal team.sections, expected
  end

  test "should collect end_of_day from params" do
    team = teams(:basic)

    TeamUpdateService.new(team, {
      "end_of_day(4i)"=>"1",
      "end_of_day(5i)"=>"45",
      "time_zone" => "Central Time (US & Canada)"
    }).call

    assert_equal team.end_of_day.hour, 6
    assert_equal team.end_of_day.min, 45
    assert_equal team.end_of_day.time_zone.name, "UTC"
  end

  test "should collect notifaction_time from params" do
    team = teams(:basic)

    TeamUpdateService.new(team, {
      "notifaction_time(4i)"=>"13",
      "notifaction_time(5i)"=>"22"
    }).call

    assert_equal team.notifaction_time.hour, 18
    assert_equal team.notifaction_time.min, 22
    assert_equal team.notifaction_time.time_zone.name, "UTC"
  end

  test "should collect metadata attributes from params" do
    team = teams(:basic)

    TeamUpdateService.new(team, {
      "project_management_url"=>"https://example.com/someroute"
    }).call

    assert_equal team.project_managementment_url, "https://example.com/someroute"
  end

  test "should overwrite metadata attributes from params" do
    team = teams(:with_metadata)

    TeamUpdateService.new(team, {
      "project_management_url"=>"https://example.com/tacos"
    }).call

    assert_equal team.project_managementment_url, "https://example.com/tacos"
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

    team.project_managementment_url

    assert_equal team.project_managementment_url, "https://radshack.com"
  end
end
