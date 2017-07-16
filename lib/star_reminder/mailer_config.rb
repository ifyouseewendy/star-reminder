# frozen_string_literal: true
module MailerConfig
  class << self
    def load(env)
      ActionMailer::Base.view_paths = File.expand_path("../views/", __FILE__)
      public_send("load_#{env}")
    end

    def load_production
      ActionMailer::Base.delivery_method = :smtp
      ActionMailer::Base.smtp_settings = {
        address: "smtp.sendgrid.net",
        port: 2525,
        user_name: "apikey",
        password: ENV["SENDGRID_API_KEY"],
        authentication: "plain",
        enable_starttls_auto: true
      }
    end

    def load_test
      ActionMailer::Base.delivery_method = :test
    end

    def load_development
      letter_file = File.expand_path("../../tmp/letter_opener", __FILE__)
      ActionMailer::Base.add_delivery_method :letter_opener, LetterOpener::DeliveryMethod, location: letter_file
      ActionMailer::Base.delivery_method = :letter_opener
    end
  end
end
