class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  unauthenticated_users_only

  def new
    # TODO: email confirmation
    @user = User.new
  end

  def create
    user = User.new(**create_params.except(:token), id: SecureRandom.uuid)
    joined_from_seat = PendingSeatJoinService.new(user:, token: create_params[:token]).join

    unless joined_from_seat
      EmailConfirmMailer.request_confirmation(user:).deliver_later
    end

    if user.save
      start_new_session_for user
      redirect_to root_path, notice: "Successfully signed up!"
    else
      render :new, alert: "Something went wrong."
    end
  end

  private

  def create_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :token)
  end
end
