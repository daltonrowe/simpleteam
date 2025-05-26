module ConfirmationConcern
  extend ActiveSupport::Concern

  class_methods do
    def user_must_be_confirmed(**options)
      before_action :redirect_unconfirmed, **options
    end
  end

  private

  def redirect_unconfirmed
    redirect_back fallback_location: dashboard_path, alert: "Must confirm email address." unless Current.user.confirmed?
  end
end
