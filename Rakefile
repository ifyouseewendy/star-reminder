# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path("./../../lib", __FILE__)
require_relative "lib/star_reminder"

task default: :run

desc "Console"
task :console do
  require "pry"
  Pry.start
end

require "rake/testtask"
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

desc "Send an email"
task :email do
  MailerConfig.load(ENV["RACK_ENV"])
  Mailer.welcome(to: "ifyouseewendy@gmail.com").deliver_now
end

desc "Fetch starred projects and send an email"
task :run do
  User.all.each(&:send_digest)
end

desc "Add new UESR with followed GITHUB_USER"
task :add_user do
  user = User.find_or_create_by(email: ENV["USER"])
  github_user = GithubUser.find_or_create_by(username: ENV["GITHUB_USER"])
  user.follow(github_user)
end

desc "Purge database"
task :purge do
  Ohm.flush
end

desc "Test StatsD integration"
task :statsd do
  StarReminder.statsd.event("This is a test message from rake statsd", "")
end
