# frozen_string_literal: true

class StatusComponent < ApplicationComponent
  def initialize(status:)
    @status = status
  end

  attr_accessor :status
  delegate :team, :sections_with_content, :user, to: :status
end
