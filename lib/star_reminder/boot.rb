# frozen_string_literal: true

require "rubygems"
require "bundler/setup"

require "dotenv"
Dotenv.load

ENV["RACK_ENV"] ||= "development"
Bundler.require(:default, ENV["RACK_ENV"])

module StarReminder
  class << self
    ENVS = %i(development test production)

    def env
      @env ||= ENV["RACK_ENV"].downcase.to_sym.tap do |rack_env|
        raise "Unknown env: #{rack_env}" unless ENVS.include?(rack_env)
      end
    end

    ENVS.each do |e|
      define_method "#{e}?" do
        public_send(:env) == e
      end
    end

    def root
      @root ||= Pathname.new("../../../").expand_path(__FILE__)
    end

    def logger
      if production?
        Logglier.new("https://logs-01.loggly.com/inputs/#{ENV['LOGGLY_API_KEY']}/tag/ruby/", threaded: true)
      else
        Logger.new STDOUT
      end
    end
  end
end

REDIS_DB = {
  development: "0",
  test: "1",
  production: "2"
}
db = REDIS_DB[StarReminder.env]
Ohm.redis = Redic.new([ENV["REDIS_HOST"].chomp("/"), db].join("/"))

ActionView::Base.send :include, OcticonsHelper
