class Admin::BaseController < ApplicationController
  layout "wide"

  before_action :require_super_admin

  private

  def require_super_admin
    redirect_to dashboard_path unless Current.user&.super_admin?
  end
end
