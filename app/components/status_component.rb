# frozen_string_literal: true

class StatusComponent < ViewComponent::Base
  def initialize(status:)
    @status = status
  end

  attr_accessor :status
  delegate :team, :sections, :user, to: :status
end
