# frozen_string_literal: true

class ExternalLinkComponent < Abstract::NavigatorComponent
  def initialize(text:, to:, style: :text, level: :primary, extra_classes: [])
    @text = text
    @to = to
    @style = style
    @level = level
    @extra_classes = [ "flex gap-1" ] + extra_classes

    super
  end

  attr_reader :text, :to, :style, :level, :extra_classes

  def call
    link_to to, class: classes do
      concat tag.span text
      concat icon
    end
  end

  def icon
    render IconComponent.new(icon: :new_tab, classes: "w-4 fill-yin-500")
  end
end
