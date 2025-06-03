# frozen_string_literal: true

class TeamComponent < ApplicationComponent
  def initialize(team:)
    @team = team
  end

  attr_accessor :team

  delegate :name, to: :team
end
