# frozen_string_literal: true
class GithubStar < Ohm::Model
  attribute :owner
  index :owner
  attribute :avatar_url
  attribute :name
  attribute :html_url
  attribute :description
  attribute :stargazers_count
  attribute :watchers_count
  attribute :forks_count
  attribute :language
  attribute :homepage
  attribute :updated_at

  reference :user, :GithubUser
end
