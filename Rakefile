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
  # Octokit.auto_paginate = true
  user = "ifyouseewendy"

  stars = Octokit.starred(user).map do |star|
    {
      avatar_url: star.owner.avatar_url,
      owner: star.owner.login,
      name: star.name,
      html_url: star.html_url,
      description: star.description,
      stargazers_count: star.stargazers_count,
      watchers_count: star.watchers_count,
      language: star.language,
      homepage: star.homepage
    }
  end
  puts "stars count: #{stars.count}"

  MailerConfig.load(ENV["RACK_ENV"])
  Mailer.welcome(to: "ifyouseewendy@gmail.com", payload: stars).deliver_now
end
