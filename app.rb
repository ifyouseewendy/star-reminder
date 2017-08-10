# frozen_string_literal: true
require_relative "lib/star_reminder"
require "sinatra/base"
require "omniauth"

class MyApp < Sinatra::Base
  use Rack::Session::Cookie
  use OmniAuth::Strategies::Developer
  use OmniAuth::Builder do
    provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"]
  end

  set :public_folder, File.dirname(__FILE__) + "/dist"

  get "/" do
    File.read("src/index.html")
  end

  get "/auth/:provider/callback" do
    begin
      auth = env["omniauth.auth"]
      email = auth["info"]["email"]
      username = auth["info"]["nickname"]
      access_token = auth["credentials"]["token"]

      user = User.create(email: email)
      github_user = GithubUser.create(username: username, access_token: access_token)
      user.follow(github_user)

      logger.info "Successfully auth callback on user: #{email} and github user: #{username}"
      { status: :succeed }.to_json
    rescue => e
      logger.error "failed on auth callback: #{e.message}"
      logger.error e.backtrace

      { status: :failed, error: { message: e.message, backtrace: e.backtrace } }.to_json
    end
  end

  private

  def logger
    @_logger ||= StarReminder.logger
  end
end
