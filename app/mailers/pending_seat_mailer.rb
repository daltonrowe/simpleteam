class PendingSeatMailer < ApplicationMailer
  def invite(email_address:, pending_seat:)
    @email_address = email_address
    @pending_seat = pending_seat

    mail subject: "SimpleTeam - Join #{pending_seat.team.name}", to: email_address
  end

  def join(email_address:, pending_seat:)
    @email_address = email_address
    @pending_seat = pending_seat

    mail subject: "SimpleTeam - Join #{pending_seat.team.name}", to: email_address
  end
end
