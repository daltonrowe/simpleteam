# frozen_string_literal: true

class Form::TimeSelectComponent < ApplicationComponent
  def initialize(form:, **args)
    @form = form
    @args = args

    super
  end

  attr_accessor :form, :args

  def call
    form.time_select(**args)
  end
end
