class DataController < ApplicationController
  before_action :find_team
  user_must_have_seat

  def index
    # list all data html

    # respond to queries json
    respond_to do |format|
      format.html { render }
    end
  end

  def show
    # display a single data record json/html
  end

  def create
    # add new data json
  end

  def destory
    # add new data
  end
end
