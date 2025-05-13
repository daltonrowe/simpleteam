# frozen_string_literal: true

class EmptySectionNoticeComponent < ViewComponent::Base
  renders_one :link

  def initialize(text:)
    @text = text
  end

  attr_reader :text
end
