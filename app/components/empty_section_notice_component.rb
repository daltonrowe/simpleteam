# frozen_string_literal: true

class EmptySectionNoticeComponent < ApplicationComponent
  renders_one :link

  def initialize(text:)
    @text = text
  end

  attr_reader :text
end
