# frozen_string_literal: true

class TeamSwitcherComponent < ApplicationComponent
  with_collection_parameter :team

  def initialize(team:, selected:, route:)
    @team = team
    @selected = selected
    @route = route
  end

  attr_reader :team, :selected, :route

  def selected_classes
    if selected == team
      return "bg-white text-yin"
    end

    "border-1 border-white text-white"
  end

  def link_path
    "#{route}/#{team.id}"
  end
end
