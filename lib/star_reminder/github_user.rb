# frozen_string_literal: true
class GithubUser < Model
  attribute :username
  unique :username
  index :username

  reference :user, :User
  collection :stars, :GithubStar, :user

  def fetch_stars
    puts "start fetching"
    # Octokit.auto_paginate = true
    Octokit.starred(username, per_page: 10).each do |star|
      GithubStar.create(
        owner: star.owner.login,
        avatar_url: star.owner.avatar_url,
        name: star.name,
        html_url: star.html_url,
        description: star.description,
        stargazers_count: star.stargazers_count,
        watchers_count: star.watchers_count,
        forks_count: star.forks_count,
        language: star.language,
        homepage: star.homepage,
        updated_on: star.updated_at,
        user: self
      )
    end
  end
end
