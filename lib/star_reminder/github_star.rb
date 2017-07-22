# frozen_string_literal: true
class GithubStar < Model
  attribute :owner
  index :owner
  attribute :avatar_url
  attribute :name
  attribute :html_url
  attribute :description
  attribute :stargazers_count, Type::Integer
  attribute :watchers_count, Type::Integer
  attribute :forks_count, Type::Integer
  attribute :language
  attribute :homepage
  attribute :updated_at, Type::Time

  reference :user, :GithubUser
end
