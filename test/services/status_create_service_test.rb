# frozen_string_literal: true

require "test_helper"

# "section"=>{"Yesterday"=>"asdfdasdf", "Today"=>"132312esdaf"}

class StatusCreateServiceTest < ActiveSupport::TestCase
  test "valid_sections returns empty array when no sections in team" do
    user = users(:owner)
    team = teams(:awesome)

    status = Status.new
    sections = {
      "Pizza": "1234"
    }

    service = StatusCreateService.new(user:, team:, status:, sections:)
    service.process_and_save

    assert_equal([], status.sections)
  end

  test "valid_sections returns sections present in status and team" do
    user = users(:owner)
    team = teams(:awesome)
    team.sections = [ { "name": "Pizza" } ]

    status = Status.new
    sections = {
      "Pizza": "here's my update"
    }

    service = StatusCreateService.new(user:, team:, status:, sections:)
    service.process_and_save

    assert_equal(
      [ { "name" => "Pizza", "content" => [ "here's my update" ] } ],
      status.sections)
  end

  test "it breaks status new lines into an array excluding empty lines" do
    user = users(:owner)
    team = teams(:awesome)
    team.sections = [ { "name": "Pizza" } ]

    status = Status.new
    sections = {
      "Pizza": "here's my update\n\n\nit has multiple line breaks"
    }

    service = StatusCreateService.new(user:, team:, status:, sections:)
    service.process_and_save

    assert_equal(
      [ { "name" => "Pizza", "content" => [ "here's my update", "it has multiple line breaks" ] } ],
      status.sections)
  end
end
