# frozen_string_literal: true
class User < Ohm::Model
  attribute :email
  unique :email
  index :email

  collection :following, :GithubUser

  def self.find_or_create_by(*args)
    find(*args).first || create(*args)
  end

  def follow(github_user)
    github_user.user = self
    github_user.save
  end
end
