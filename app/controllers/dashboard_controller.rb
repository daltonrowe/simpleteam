class DashboardController < ApplicationController
  def index
    @teams = Current.user.teams
  end
end
