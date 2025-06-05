class StatusesController < ApplicationController
  user_must_have_seat
  before_action :find_fresh_status, only: %i[update]
  def create
    status = Status.new(user: Current.user, team: @team, id: SecureRandom.uuid)
    status.update_sections(params[:sections])

    if status.save
      redirect_to dashboard_path, notice: "Status saved!"
    else
      redirect_to dashboard_path, alert: "Something went wrong."
    end
  end

  def update
    @status.update_sections(params[:sections])

    if @status.save
      redirect_to dashboard_path, notice: "Status saved!"
    else
      redirect_to dashboard_path, alert: "Something went wrong."
    end
  end

  private

  def find_fresh_status
    @status = Status.find(params[:id])
    redirect_to dashboard_path, alert: "Status too old, cannot be updated." unless @status.fresh?
  end
end
