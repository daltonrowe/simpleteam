module CaptchaConcern
  extend ActiveSupport::Concern
  include HTTParty

  def verify_captcha
    response = HTTParty.post(Rails.application.credentials.turnstile_challenge_url,
      body: { response: params[:cf_token], secret:  Rails.application.credentials.turnstile_secret_key }.to_json,
      headers: { "Content-Type" => "application/json" }
    )

    @captcha_valid = response["success"] == true
  end
end
