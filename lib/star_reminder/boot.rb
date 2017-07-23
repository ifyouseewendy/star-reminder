# frozen_string_literal: true

require "rubygems"
require "bundler/setup"

require "dotenv"
Dotenv.load

ENV["RACK_ENV"] ||= "development"

Bundler.require(:default, ENV["RACK_ENV"])
ActionView::Base.send :include, OcticonsHelper

db = ENV["RACK_ENV"] == "test" ? "1" : "0"
Ohm.redis = Redic.new([ENV["REDIS_HOST"].chomp("/"), db].join("/"))
