# frozen_string_literal: true
class GithubUser < Model
  attribute :username
  unique :username
  index :username

  attribute :access_token
  unique :access_token

  reference :user, :User
  collection :stars, :GithubStar, :user

  def fetch_stars
    client = Octokit::Client.new(access_token: access_token, auto_paginate: true)
    client
      .starred(username)
      .tap { |s| logger.info "Fetched #{s.count} stars from #{self} for #{user}" }
      .each { |star| GithubStar.find_or_create_by(star.to_hash, self) }
  end

  def to_s
    "#{self.class.name}<#{username}>"
  end
end
