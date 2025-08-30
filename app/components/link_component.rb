# frozen_string_literal: true

class LinkComponent < Abstract::NavigatorComponent
  def initialize(text:, to: nil, style: :text, level: :primary, element: nil, external: false)
    @text = text
    @to = to
    @style = style
    @level = level
    @element_attrs = element
    @external = external

    super
  end

  attr_reader :text, :to, :style, :level, :element_attrs, :external

  def call
    attrs = {
      class: classes
    }

    if external
      attrs[:target] = "_blank"
      attrs[:rel] = "nofollow noreferrer noopener"
    end

    link_to(text, to, **merge_html_attrs(attrs, element_attrs))
  end
end
