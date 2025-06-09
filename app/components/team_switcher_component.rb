# frozen_string_literal: true

class TeamSwitcherComponent < ApplicationComponent
  with_collection_parameter :team

  def initialize(team:)
    @team = team
  end

  attr_reader :team
end
