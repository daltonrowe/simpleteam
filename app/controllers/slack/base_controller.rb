module Slack
  class BaseController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_slack_request!

    allow_unauthenticated_access

    def authenticate_slack_request!
      Slack::Events::Request.new(request).verify!
    rescue
      render json: { error: "Invalid Signature" }, status: 401
    end
  end
end
