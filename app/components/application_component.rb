class ApplicationComponent < ViewComponent::Base
  alias_method :original_form_with, :form_with

  def form_with(**args, &block)
    original_form_with(**args, builder: SimpleTeamFormBuilder, &block)
  end
end
