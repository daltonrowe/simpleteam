# frozen_string_literal: true

class StatusInputComponent < ViewComponent::Base
  def initialize(status:)
    @status = status
  end

  attr_accessor :status
  delegate :team, :sections, to: :status

  def form_attrs
    return { url: team_status_path(team, @status), method: :patch } if status

    { url: team_statuses_path(team), method: :post }
  end

  def section_value(name)
    return "" unless status

    puts status.inspect
    sections.detect { |section| section["name"] == name }["content"].join("\n")
  end

  def submit_text
    return "Update" if status

    "Submit"
  end

  def cutoff_time
    distance_of_time_in_words(team.next_cutoff, Time.zone.now)
  end
end
