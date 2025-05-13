# frozen_string_literal: true

class SiteHeaderComponent < ViewComponent::Base
  renders_one :badge, ->(args) do
    BadgeComponent.new(**args)
  end
end
