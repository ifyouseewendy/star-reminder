# frozen_string_literal: true
class GithubStar < Model
  attribute :owner
  index :owner
  attribute :avatar_url
  attribute :name
  index :name
  attribute :html_url
  attribute :description
  attribute :stargazers_count, Type::Integer
  attribute :watchers_count, Type::Integer
  attribute :forks_count, Type::Integer
  attribute :language
  attribute :homepage
  attribute :updated_on, Type::Time

  reference :user, :GithubUser

  def self.find_or_create_by(star, user)
    return if user.stars.find(owner: star[:owner][:login], name: star[:name]).count.positive?

    create(
      owner: star[:owner][:login],
      avatar_url: star[:owner][:avatar_url],
      name: star[:name],
      html_url: star[:html_url],
      description: star[:description],
      stargazers_count: star[:stargazers_count],
      watchers_count: star[:watchers_count],
      forks_count: star[:forks_count],
      language: star[:language],
      homepage: star[:homepage],
      updated_on: star[:updated_at],
      user: user
    )
  end

  def to_s
    "#{self.class.name}<#{owner}/#{name}>"
  end
end
