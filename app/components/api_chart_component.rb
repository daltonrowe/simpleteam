# frozen_string_literal: true

class ApiChartComponent < ApplicationComponent
  def initialize(name:, team:, keys:)
      @name = name
      @team = team
      @keys = keys

      super
  end

  attr_accessor :name, :team, :keys

  def call
    tag.div class: "aspect-video bg-yin-800 rounded-lg", data: {
      api_chart_name_value: name,
      api_chart_team_value: team.id,
      api_chart_api_key_value: team.data_api_key,
      api_chart_keys_value: keys
    }
  end
end
