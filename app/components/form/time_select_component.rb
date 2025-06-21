# frozen_string_literal: true

class Form::TimeSelectComponent < ApplicationComponent
  def initialize(form:, method:, **args)
    @form = form
    @method = method
    @args = args

    super
  end

  attr_accessor :form, :method, :args

  def call
    form.time_select(method, **args)
  end
end
