class DataController < ApplicationController
  respond_to :json
  before_action :find_team
  before_action :validate_api_key

  def index
  end

  private

  def validate_api_key
    puts "hey!"
  end
end
