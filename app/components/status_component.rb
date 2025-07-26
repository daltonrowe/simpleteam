# frozen_string_literal: true

class StatusComponent < ApplicationComponent
  def initialize(status:)
    @status = status
  end

  attr_accessor :status
  delegate :team, :sections_with_content, :user, to: :status

  private

  def transformed_content(content)
    # this output is raw so sanitization must be manual
    content = strip_tags(content)

    if team.project_managementment_url
      content = content.gsub(/[A-Z]+-[0-9]+/) { |s| render ExternalLinkComponent.new(text: s, to: "#{team.project_managementment_url}#{s}") }
    end

    content
  end
end
