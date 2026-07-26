class Admin::UsersController < Admin::BaseController
  def index
    @users = User.order(:email_address)
  end
end
