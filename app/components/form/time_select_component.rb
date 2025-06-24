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
    tag.div class: "border p-2 rounded" do
      form.time_select(method, **args)
    end
  end
end
