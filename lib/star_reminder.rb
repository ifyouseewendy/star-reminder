# frozen_string_literal: true
require "rubygems"
require "bundler/setup"

require "dotenv"
Dotenv.load

ENV["RACK_ENV"] ||= "development"

Bundler.require(:default, ENV["RACK_ENV"])
ActionView::Base.send :include, OcticonsHelper

require_relative "star_reminder/mailer_config"
require_relative "star_reminder/mailer"
require_relative "star_reminder/github_star"

Ohm.redis = Redic.new(ENV["REDIS_HOST"])
