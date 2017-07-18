# frozen_string_literal: true
require "rubygems"
require "bundler/setup"

require "dotenv"
Dotenv.load
ENV["RACK_ENV"] ||= "development"

require "octokit"
require "action_mailer"
require "letter_opener" unless "production" == ENV["RACK_ENV"]
require "roadie-rails"

require_relative "star_reminder/mailer_config"
require_relative "star_reminder/mailer"
