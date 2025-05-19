class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  unauthenticated_users_only

  def new
    @user = User.new
  end

  def create
    ActiveRecord::Base.transaction do
      @user = User.new(**create_params.except(:token), id: SecureRandom.uuid)
      PendingSeatJoinService.new(user: @user, token: create_params[:token]).join
    end

    if @user.save
      start_new_session_for @user
      redirect_to root_path, notice: "Successfully signed up!"
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :token)
  end
end
