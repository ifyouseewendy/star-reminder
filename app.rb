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
  use Rack::Parser,
    parsers: {
      "application/json" => proc { |data| JSON.parse(data).symbolize_keys }
    },
    handlers: {
      "application/json" => proc { |_e, type| [400, { "Content-Type" => type }, ["broke"]] }
    }

  enable :sessions
  set :session_secret, ENV.fetch("SESSION_SECRET") { SecureRandom.hex(64) }

  set :public_folder, File.dirname(__FILE__) + "/dist"
  set :views, File.dirname(__FILE__) + "/src"

  set :server, :puma

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
        count: user.digest_count,
        frequency: user.digest_frequency,
        hour: user.digest_hour,
        meridiem: user.digest_meridiem
      }
    }.to_json
  end

  post "/user/digest" do
    email = session[:email]
    user = User.find(email: email).first
    halt 401 if user.nil?

    begin
      user.update(
        digest_count: params[:count],
        digest_frequency: params[:frequency],
        digest_hour: params[:hour],
        digest_meridiem: params[:meridiem]
      )
      { status: :succeed, msg: "Successfully update user digest" }
        .tap { |h| logger.info h.merge(params: params) }
        .to_json
    rescue => e
      {
        status: :failed,
        msg: "Failed update user digest",
        error: { message: e.message, backtrace: e.backtrace }
      }.tap { |h| logger.error h.merge(params: params) }.to_json
    end
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
