class ApplicationController < ActionController::Base
  include AuthenticationConcern
  include ConfirmationConcern
  include TeamsConcern
  default_form_builder SimpleTeamFormBuilder

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def find_or_create_slack_user(slack_user_id, token, slack_installation)
    client = Slack::Web::Client.new(token: token)
    user_info = client.users_info(user: slack_user_id).user.profile
    slack_user = SlackUser.find_by(slack_user_id: slack_user_id)

    if slack_user
      slack_user.user
    else
      user = User.create_with(
        id: SecureRandom.uuid,
        name: user_info.real_name,
        email_address: user_info.email,
        password: SecureRandom.uuid)
                 .find_or_create_by!(email_address: user_info.email)
      SlackUser.create!(id: SecureRandom.uuid, slack_user_id:, user_id: user.id, slack_installation:)
      user
    end
  end

  def current_host
    request.protocol + request.host_with_port
  end

  helper_method :current_host
end
