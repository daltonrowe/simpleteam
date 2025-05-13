class SeatsController < ApplicationController
  user_must_have_pending_seat only: %i[create]
  user_must_have_seat only: %i[destroy]
  def create
    ActiveRecord::Base.transaction do
      Seat.create(user: Current.user, team: @pending_seat.team)
      @pending_seat.destroy
    end

    redirect_back fallback_location: root_path
  end
  def destroy
    seat = Seat.find_by(id: params[:id])
    seat.destroy

    redirect_back fallback_location: root_path
  end
end
