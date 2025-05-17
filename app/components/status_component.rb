# frozen_string_literal: true

class StatusComponent < ViewComponent::Base
  def initialize(seat: nil, team: nil, status: nil)
    @seat = seat
    @team = team || seat.team
    @status = status
  end

  attr_accessor :team, :status

  def form_attrs
    return { url: team_statuses_path(team.guid, @status), method: :patch } if status

    { url: team_statuses_path(team.guid), method: :post }
  end

  def section_value(name)
    return nil unless status

    status.sections.detect { |section| section["name"] == name }["content"].join("\n")
  end
end
