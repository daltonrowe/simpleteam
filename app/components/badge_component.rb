# frozen_string_literal: true

class BadgeComponent < ViewComponent::Base
  def initialize(text:, path: nil, method: :get)
    @text = text
    @path = path
    @turbo_method = method
  end

  attr_reader :text, :path, :turbo_method

  CLASSES = "rounded-3xl bg-white text-yin py-2 px-4"

  def call
    return tag.a text, href: path, class: CLASSES, data: {
      turbo_method:
    } if path

    tag.div text, class: CLASSES
  end
end
