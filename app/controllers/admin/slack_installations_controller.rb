class Admin::SlackInstallationsController < Admin::BaseController
  def index
    @slack_installations = SlackInstallation.includes(:user, :teams).order(:name)
  end
end
