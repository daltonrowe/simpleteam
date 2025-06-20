class PendingSeatsController < ApplicationController
  user_must_own_team except: %i[destroy]
  user_must_have_pending_seat only: %i[destroy]
  user_must_be_confirmed only: %i[create]

  def create
    PendingSeatInviteService.new(team: @team, pending_emails: create_params[:pending_emails]).create_seats

    redirect_to edit_team_path(@team), notice: "Team invitiations sent!"
  end

  def destroy
    pending_seat = PendingSeat.find_by(id: params[:id])
    pending_seat.destroy

    redirect_to edit_team_path(@team)
  end

  private

  def create_params
    params.permit(:pending_emails)
  end
end
