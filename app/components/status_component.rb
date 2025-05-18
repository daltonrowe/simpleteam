# frozen_string_literal: true

class StatusComponent < ViewComponent::Base
  def initialize(seat: nil, team: nil, status: nil)
    @seat = seat
    @team = team || seat.team
    @status = status
  end

  attr_accessor :team, :status

  def form_attrs
    return { url: team_status_path(team.guid, @status.id), method: :patch } if status

    { url: team_statuses_path(team.guid), method: :post }
  end

  def section_value(name)
    return "" unless status

    status.sections.detect { |section| section["name"] == name }["content"].join("\n")
  end

  def submit_text
    return "Update" if status

    "Submit"
  end

  def cutoff_time
    distance_of_time_in_words(team.today_cutoff, Time.zone.now)
  end
end
