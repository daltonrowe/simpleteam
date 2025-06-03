# frozen_string_literal: true

class SectionHeaderComponent < ApplicationComponent
  def initialize(text:, badge: nil)
    @text = text
    @badge = badge
  end

  attr_reader :text, :badge
end
