# frozen_string_literal: true

class AlertComponent < ViewComponent::Base
  def initialize(text:, level: :alert)
    @text = text
    @level = level
  end

  attr_reader :text, :type, :level

  def call
    tag.div text, class: classes
  end

  def classes
    class_array = [ "py-2", "px-3", "font-medium", "rounded-lg" ]

    class_array.push("bg-red-50", "text-red-500") if level == :alert
    class_array.push("bg-green-50", "text-green-500") if level == :notice

    class_array.join(" ")
  end
end
