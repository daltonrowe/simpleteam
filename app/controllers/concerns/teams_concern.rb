module TeamsConcern
  extend ActiveSupport::Concern
  include ApplicationHelper

  class_methods do
    def user_must_own_team(**options)
      before_action :redirect_non_owners, **options
    end

    def user_must_have_seat(**options)
      before_action :redirect_non_members, **options
    end

    def user_must_have_pending_seat(**options)
      before_action :redirect_non_pending, **options
    end
  end

  private

  def find_team
    @team = Team.find(params[:team_id] || params[:id])

    redirect_to dashboard_path unless @team
  end

  def find_pending_seat
    @pending_seat = @team.pending_seats_for Current.user
  end

  def redirect_non_owners
    find_team
    redirect_to dashboard_path unless Current.user.owns? @team
  end

  def redirect_non_members
    find_team
    redirect_to dashboard_path unless Current.user.member_of? team
  end

  def redirect_non_pending
    find_team
    find_pending_seat
    redirect_to dashboard_path unless Current.user.owns?(@team)|| @pending_seat
  end
end
