# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path("./../../lib", __FILE__)
require_relative "lib/star_reminder"

task default: :run

task :console do
  require "pry"
  Pry.start
end

desc "Send an email"
task :email do
  MailerConfig.load(ENV["RACK_ENV"])
  Mailer.welcome(to: "ifyouseewendy@gmail.com").deliver_now
end

desc "Fetch starred projects and send an email"
task :run do
  email = "ifyouseewendy@gmail.com"
  user = User.find_or_create_by(email: email)

  username = "ifyouseewendy"
  github_user = GithubUser.find_or_create_by(username: username)

  user.follow(github_user) unless user.following.include? github_user

  github_user.fetch_stars if github_user.stars.count.zero?
  stars = github_user.stars
  puts "stars count: #{stars.count}"

  MailerConfig.load(ENV["RACK_ENV"])
  Mailer.welcome(to: "pierowendy@gmail.com", payload: stars).deliver_now
end
