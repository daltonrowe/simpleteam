class StatusesController < ApplicationController
  user_must_have_seat
  def create
    sections = StatusFormatterService.new(team: @team, sections: params[:sections]).format
    status = Status.new(user: Current.user, team: @team, sections:, id: SecureRandom.uuid)

    if status.save
      redirect_to dashboard_path, notice: "Status saved!"
    else
      redirect_to dashboard_path, alert: "Something went wrong."
    end
  end

  def update
    status = Status.find(params[:id])

    return redirect_to dashboard_path, alert: "Status too old, cannot be updated." unless status.fresh?

    sections = StatusFormatterService.new(team: @team, sections: params[:sections]).format

    if status.update(sections:)
      redirect_to dashboard_path, notice: "Status saved!"
    else
      redirect_to dashboard_path, alert: "Something went wrong."
    end
  end
end
