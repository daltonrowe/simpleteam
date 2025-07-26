# frozen_string_literal: true

class LinkComponent < Abstract::NavigatorComponent
  def initialize(text:, to: nil, style: :text, level: :primary, extra_classes: [])
    @text = text
    @to = to
    @style = style
    @level = level
    @extra_classes = extra_classes

    super
  end

  attr_reader :text, :to, :style, :level, :extra_classes

  def call
    return link_to text, to, class: classes if to.present?

    tag.a text, nil, class: classes
  end
end
