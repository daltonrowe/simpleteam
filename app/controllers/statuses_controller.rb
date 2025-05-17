class StatusesController < ApplicationController
  user_must_have_seat
  def create
    # TODO: check and save status
    #


    puts params
  end

  private

  def create_params
    params.require(:status).permit()
  end
end
