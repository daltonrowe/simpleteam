# frozen_string_literal: true

class EmptySectionNoticeComponent < ViewComponent::Base
  def initialize(text:)
    @text = text
  end

  attr_reader :text
end
