# frozen_string_literal: true
class GithubUser < Model
  attribute :username
  unique :username
  index :username

  reference :user, :User
  collection :stars, :GithubStar, :user

  def fetch_stars
    Octokit.auto_paginate = true
    Octokit
      .starred(username, per_page: 10)
      .tap { |s| logger.info "Fetched #{s.count} stars from #{self} for #{user}" }
      .each { |star| GithubStar.find_or_create_by(star.to_hash, self) }
  end

  def to_s
    "#{self.class.name}<#{username}>"
  end
end
