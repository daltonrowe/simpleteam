# frozen_string_literal: true

require "test_helper"

# "section"=>{"Yesterday"=>"asdfdasdf", "Today"=>"132312esdaf"}

class StatusFormatterServiceTest < ActiveSupport::TestCase
  test "returns empty array when no sections in team" do
    team = teams(:awesome)
    sections = {
      "Pizza": "1234"
    }

    service = StatusFormatterService.new(team:, sections:)

    assert_equal([], service.format)
  end

  test "valid_sections returns sections present in status and team" do
    team = teams(:awesome)
    team.sections = [ { "name": "Pizza" } ]
    sections = {
      "Pizza": "here's my update"
    }

    service = StatusFormatterService.new(team:, sections:)
    assert_equal(
      [ { name: "Pizza", content: [ "here's my update" ] } ],
      service.format)
  end

  test "it breaks status new lines into an array excluding empty lines" do
    team = teams(:awesome)
    team.sections = [ { "name": "Pizza" } ]
    sections = {
      "Pizza": "here's my update\n\n\nit has multiple line breaks"
    }

    service = StatusFormatterService.new(team:, sections:)

    assert_equal(
      [ { name: "Pizza", content: [ "here's my update", "it has multiple line breaks" ] } ],
      service.format)
  end
end
