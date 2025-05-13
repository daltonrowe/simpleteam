# frozen_string_literal: true

class BadgeComponent < ViewComponent::Base
  def initialize(text:, path: nil)
    @text = text
    @path = path
  end

  attr_reader :text, :path

  CLASSES = "rounded-3xl bg-white text-yin py-2 px-4"

  def call
    return tag.a text, href: path, class: CLASSES if path

    tag.div text, class: CLASSES
  end
end
