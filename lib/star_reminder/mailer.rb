# frozen_string_literal: true
class Mailer < ActionMailer::Base
  include Roadie::Rails::Automatic

  default from: "Di Wen <ifyouseewendy@gmail.com>", subject: "Github Star Reminder"
  layout "mailer"

  helper do
    def colors
      @_colors ||= JSON.parse File.read(StarReminder.root.join("resource/colors.json"))
    end
  end

  def welcome(to:, payload: {})
    @payload = payload
    mail(to: to)
  end

  private

  def roadie_options
    @roadie_options ||= Roadie::Rails::Options.new(
      asset_providers: Roadie::FilesystemProvider.new(StarReminder.root.join("lib/star_reminder/assets"))
    )
  end
end
