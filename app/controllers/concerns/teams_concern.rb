module TeamsConcern
  extend ActiveSupport::Concern

  class_methods do
    def user_must_own_team(**options)
      before_action :find_team, **options
      before_action :redirect_non_owners, **options
    end

    def user_must_have_seat(**options)
      before_action :find_team, **options
      before_action :redirect_non_members, **options
    end
  end

  private

  def find_team
    @team = Team.find_by(guid: params[:team_id] || params[:id])
    redirect_to root_path unless @team
  end

  def redirect_non_owners
    redirect_to root_path unless user_owns_team
  end

  def redirect_non_members
    redirect_to root_path unless user_owns_team || user_on_team
  end

  def user_owns_team
    Current.user == @team.user
  end

  def user_has_seat
     Current.user.seats.where(team: @team)
  end
end
