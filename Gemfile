# frozen_string_literal: true
source "https://rubygems.org"

gem "octokit", "~> 4.0"
gem "actionmailer", require: "action_mailer"
gem "roadie-rails"
gem "dotenv"
gem "octicons_helper"
gem "ohm"
gem "ohm-contrib"
gem "whenever", require: false
gem "dogstatsd-ruby", require: "datadog/statsd"
gem "sinatra"
gem "omniauth"
gem "omniauth-github"

group :development do
  gem "letter_opener"
  gem "pry-byebug"
  gem "awesome_print"
  gem "foreman"
  gem "shotgun"
end

group :test do
  gem "minitest"
  gem "mocha"
end

group :production do
  gem "logglier", "~> 0.2.11"
end
