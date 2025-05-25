class EmailConfirmMailer < ApplicationMailer
  include EncryptionHelper

  def request_confirmation(user:)
    @user = user
    @expires_at = Time.zone.now + 15.minutes
    @token = user_token(@user.email_address, @expires_at, "email_confirm")

    mail subject: "SimpleTeam - Confirm Your Email Address", to: user.email_address
  end
end
