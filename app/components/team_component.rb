# frozen_string_literal: true

class TeamComponent < ViewComponent::Base
  def initialize(team:)
    @team = team
  end

  attr_accessor :team

  delegate :name, to: :team
end
