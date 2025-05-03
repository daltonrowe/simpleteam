# frozen_string_literal: true

class ButtonComponent < Abstract::NavigatorComponent
  def initialize(text:, type: nil, to: nil, method: nil, style: :filled, level: :primary, form: nil, extra_classes: nil)
    @text = text
    @type = type
    @to = to
    @method = method
    @style = style
    @level = level
    @form = form
    @extra_classes = extra_classes

    super
  end

  attr_reader :text, :type, :to, :method, :style, :level, :form, :extra_classes

  def call
    return button_to text, to, method:, form:, class: classes if to.present?

    tag.button text, type:, class: classes
  end
end
