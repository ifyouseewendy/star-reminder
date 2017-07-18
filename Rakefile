# frozen_string_literal: true
require_relative "lib/star_reminder"

desc "Send a test email"
task :email do
  MailerConfig.load(ENV["RACK_ENV"])
  Mailer.welcome(to: "ifyouseewendy@gmail.com", subject: "Hi from Star Reminder").deliver_now
end
