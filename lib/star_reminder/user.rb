# frozen_string_literal: true
class User < Model
  attribute :email
  unique :email
  index :email

  collection :following, :GithubUser

  def follow(github_user)
    github_user.user = self
    github_user.save
  end
end
