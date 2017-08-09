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
    auth = env["omniauth.auth"]
    access_token = auth["credentials"]["token"]

    # Octokit
    client = Octokit::Client.new(access_token: access_token) # auto_paginate: true
    client.starred("ifyouseewendy", per_page: 3).to_json
  end
end
