class HomeController < ApplicationController
  allow_unauthenticated_access
  before_action :resume_session

  unauthenticated_users_only
  def index; end
end
