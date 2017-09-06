# frozen_string_literal: true

require "rubygems"

ENV["RACK_ENV"] = "development" if ENV["RACK_ENV"].nil? || ENV["RACK_ENV"].empty?
Bundler.require(:default, ENV["RACK_ENV"])

require "dotenv"
Dotenv.load
Dotenv.load(ENV["ENV_PRODUCTION"]) if ENV["RACK_ENV"].downcase.to_sym == :production

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
      Logger.new STDOUT
    end

    def statsd
      host, port = ENV["DATADOG_HOST"].to_s.split(":")
      opts = { namespace: name }
      Datadog::Statsd.new(host, port, opts)
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
