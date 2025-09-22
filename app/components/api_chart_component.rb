# frozen_string_literal: true

class ApiChartComponent < ApplicationComponent
  def initialize(name:, team:, keys:)
      @name = name
      @team = team
      @keys = keys

      super
  end

  attr_accessor :name, :team, :keys
end
