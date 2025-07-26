# frozen_string_literal: true

class IconComponent < ApplicationComponent
  def initialize(icon:, classes:)
      @icon = icon
      @classes = classes

      super
  end

  attr_accessor :icon, :classes

  def call
    transform file
  end

  private

  def file
    File.read("app/assets/icons/#{icon}.svg")
  end

  def transform(svg)
    svg.gsub('xmlns="http://www.w3.org/2000/svg"', "xmlns=\"http://www.w3.org/2000/svg\" class='#{classes}'").html_safe
  end
end
