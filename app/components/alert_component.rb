# frozen_string_literal: true

class AlertComponent < ApplicationComponent
  def initialize(text:, level: :alert)
    @text = text
    @level = level
  end

  attr_reader :text, :type, :level

  def call
    tag.div text, class: classes, data: { controller: "auto-remove" }
  end

  def classes
    class_array = [ "py-2", "px-3", "font-medium", "rounded-lg" ]

    class_array.push("bg-red-500", "text-red-50") if level == :alert
    class_array.push("bg-green-500", "text-green-50") if level == :notice

    class_array.join(" ")
  end
end
