# frozen_string_literal: true

class StatusInputComponent < ApplicationComponent
  def initialize(status:, is_draft: false)
    @status = status
    @is_draft = is_draft
  end

  attr_accessor :status, :is_draft

  delegate :team, :sections, :created_at, to: :status

  def form_attrs
    { url:, method: }
  end

  def url
    team_statuses_path(team) if is_draft
    team_status_path(team, status) if created_at

    team_statuses_path(team)
  end

  def method
    :patch if created_at

    :post
  end

  def section_value(name)
    section = sections.detect { |section| section["name"] == name }
    return nil unless section

    section["content"].join("\n")
  end

  def submit_text
    return "Save Draft" if is_draft
    return "Update" if created_at

    "Submit"
  end

  def cutoff_time
    distance_of_time_in_words(team.next_cutoff, Time.zone.now)
  end
end
