class UsersController < ApplicationController
  def edit
    @pending_seats = Current.user.pending_seats
  end

  def update
    # TODO: allow updating email, reconfirm address
    Current.user.assign_attributes(update_params)

    if Current.user.save
      redirect_back fallback_location: root_path, notice: "User updated!"
    else
      redirect_back fallback_location: root_path, alert: "Something went wrong."
    end
  end

  private

  def update_params
    params.require(:user).permit(:name)
  end
end
