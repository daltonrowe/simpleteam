class PendingSeatsController < ApplicationController
  def create
    puts create_params
  end

  private

  def create_params
    params.require(:team_seats).permit(:team_guid, :pending_emails)
  end
end
