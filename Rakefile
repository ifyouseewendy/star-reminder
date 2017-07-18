# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path("./../../lib", __FILE__)
require_relative "lib/star_reminder"

task default: :console

task :console do
  require "pry"
  Pry.start
end

desc "Send an email"
task :email do
  MailerConfig.load(ENV["RACK_ENV"])
  Mailer.welcome(to: "ifyouseewendy@gmail.com").deliver_now
end
