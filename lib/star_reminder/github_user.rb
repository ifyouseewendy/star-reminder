# frozen_string_literal: true
class GithubUser < Model
  attribute :username
  unique :username
  index :username

  reference :user, :User
  collection :stars, :GithubStar, :user

  def fetch_stars
    logger.info "start fetching"
    # Octokit.auto_paginate = true
    Octokit.starred(username, per_page: 10).each do |star|
      GithubStar.find_or_create_by(star.to_hash, self)
    end
  end
end
