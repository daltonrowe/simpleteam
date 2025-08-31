class DataController < ApplicationController
  before_action :find_team
  user_must_have_seat

  def idnex
end
