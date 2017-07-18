# frozen_string_literal: true
class Mailer < ActionMailer::Base
  default from: "Di Wen <ifyouseewendy@gmail.com>", subject: "Github Star Reminder"
  layout "mailer"

  def welcome(to:, payload: {})
    @payload = payload
    mail(to: to)
  end
end
