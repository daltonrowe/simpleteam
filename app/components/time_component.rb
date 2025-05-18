# frozen_string_literal: true

class TimeComponent < ViewComponent::Base
  def initialize(time:, format: nil)
    @time = time
    @format = format
  end

  attr_reader :time, :format

  def call
    tag.time time, datetime: time, data: {
      controller: "time",
      time_format_value: format
    }
  end
end
