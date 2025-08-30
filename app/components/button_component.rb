# frozen_string_literal: true

class ButtonComponent < Abstract::NavigatorComponent
  def initialize(text:, type: nil, to: nil, method: nil, style: :filled, level: :primary, form: nil, element: nil)
    @text = text
    @type = type
    @to = to
    @method = method
    @style = style
    @level = level
    @form = form
    @element_attrs = element

    super
  end

  attr_reader :text, :type, :to, :method, :style, :level, :form, :element_attrs

  def call
    attrs = {
      method:,
      form:,
      class: classes
    }

    return button_to(text, to, **merge_html_attrs(attrs, element_attrs)) if to.present?

    tag.button(text, type:, **merge_html_attrs(attrs, element_attrs))
  end
end
