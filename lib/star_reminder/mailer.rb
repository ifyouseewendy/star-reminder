# frozen_string_literal: true
class Mailer < ActionMailer::Base
  default from: "Di Wen <ifyouseewendy@gmail.com>"
  layout "mailer"

  def welcome(to:, subject:)
    mail(to: to, subject: subject)
  end
end
