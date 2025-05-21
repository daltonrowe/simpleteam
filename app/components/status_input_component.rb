# frozen_string_literal: true

class StatusInputComponent < ViewComponent::Base
  def initialize(status:)
    @status = status
  end

  attr_accessor :status
  delegate :team, :sections, :created_at, to: :status

  def form_attrs
    { url:, method: }
  end

  def url
    created_at ? team_status_path(team, status) : team_statuses_path(team)
  end

  def method
    created_at ? :patch : :post
  end

  def section_value(name)
    return "" unless created_at

    sections.detect { |section| section["name"] == name }["content"].join("\n")
  end

  def submit_text
    return "Update" if created_at

    "Submit"
  end

  def cutoff_time
    distance_of_time_in_words(team.next_cutoff, Time.zone.now)
  end
end
