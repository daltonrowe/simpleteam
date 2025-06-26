class RegistrationsController < ApplicationController
  include EncryptionHelper
  allow_unauthenticated_access
  unauthenticated_users_only

  def new
    begin
      @valid_token = user_token_data(params[:token]) if params[:token]
    rescue OpenSSL::Cipher::CipherError
      flash[:alert] = "Invalid token."
    end

    @user = User.new(email_address: @valid_token&.[](:token_email))
  end

  def create
    @user = User.new(**create_params.except(:token), id: SecureRandom.uuid)
    joined_from_seat = PendingSeatJoinService.new(user: @user, token: create_params[:token]).join

    unless joined_from_seat
      EmailConfirmMailer.request_confirmation(user: @user).deliver_later
    end

    if @user.save
      start_new_session_for @user
      redirect_to dashboard_path, notice: "Successfully signed up!"
    else
      render :new, alert: "Something went wrong."
    end
  end

  private

  def create_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :token)
  end
end
