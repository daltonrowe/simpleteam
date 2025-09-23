# frozen_string_literal: true

class ApiChartComponent < ApplicationComponent
  def initialize(name:, team:, keys:, host:)
      @name = name
      @team = team
      @keys = keys
      @host = host

      super
  end

  attr_accessor :name, :team, :keys, :host

  def call
    tag.div class: "aspect-[3/1] bg-yin-800 rounded-lg py-2 px-4", data: {
      controller: "api-chart",
      api_chart_name_value: name,
      api_chart_team_id_value: team.id,
      api_chart_api_key_value: team.data_api_key,
      api_chart_host_value: host,
      api_chart_keys_value: keys
    } do
      tag.canvas class: "w-full h-full", data: {
        api_chart_target: "canvas"
      }
    end
  end
end
