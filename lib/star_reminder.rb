# frozen_string_literal: true
require_relative "star_reminder/boot"

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
  end
end

require_relative "star_reminder/mailer_config"
require_relative "star_reminder/mailer"
require_relative "star_reminder/model"
require_relative "star_reminder/user"
require_relative "star_reminder/github_user"
require_relative "star_reminder/github_star"

MailerConfig.load(StarReminder.env)
