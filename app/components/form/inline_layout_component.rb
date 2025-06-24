# frozen_string_literal: true

class Form::InlineLayoutComponent < ApplicationComponent
  def initialize(label:)
    @label = label
    super
  end

  attr_reader :label
end
