class SimpleTeamFormBuilder < ActionView::Helpers::FormBuilder
  def simple_submit(**args, &block)
    defaults = {
      type: :submit
    }

    view_context.render ButtonComponent.new(**defaults.merge(args))
  end

  private

  def view_context
    @view_context ||= ApplicationController.new.view_context
  end
end
