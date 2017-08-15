# frozen_string_literal: true
require_relative "lib/star_reminder"
require "sinatra/base"
require "omniauth"
require "omniauth-github"
require "securerandom"

class MyApp < Sinatra::Base
  use OmniAuth::Strategies::Developer
  use OmniAuth::Builder do
    provider :github, ENV["GITHUB_KEY"], ENV["GITHUB_SECRET"]
  end

  enable :sessions
  set :session_secret, ENV.fetch("SESSION_SECRET") { SecureRandom.hex(64) }

  set :public_folder, File.dirname(__FILE__) + "/dist"
  set :views, File.dirname(__FILE__) + "/src"

  get "/" do
    File.read("src/index.html")
  end

  get "/user" do
    email = session[:email]
    user = User.find(email: email).first
    return {}.to_json if user.nil?

    {
      email: email,
      githubUserName: user.following.first.username,
      digest: {
        frequency: "every week",
        hour: 8,
        meridiem: "am",
        count: user.digest_count
      }
    }.to_json
  end

  get "/auth/:provider/callback" do
    begin
      auth = env["omniauth.auth"]
      email, username = auth["info"].values_at("email", "nickname")
      access_token = auth["credentials"]["token"]

      if User.find(email: email).first
        session[:email] = email
        redirect to("/")
      end

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
