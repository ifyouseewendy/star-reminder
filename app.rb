# frozen_string_literal: true
require_relative "lib/star_reminder"
require "sinatra/base"
require "omniauth"
require "securerandom"

class MyApp < Sinatra::Base
  use Rack::Session::Cookie
  use OmniAuth::Strategies::Developer
  use OmniAuth::Builder do
    provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"]
  end

  enable :sessions
  set :session_secret, ENV.fetch("SESSION_SECRET") { SecureRandom.hex(64) }

  set :public_folder, File.dirname(__FILE__) + "/dist"
  set :views, File.dirname(__FILE__) + "/src"

  get "/" do
    # File.read("src/index.html")
    erb :"index.html", locals: { view: { email: "wendi" } }
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

      session[:email] = email
      logger.info "Successfully auth callback on user: #{email} and github user: #{username}"

      redirect to("/")
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
