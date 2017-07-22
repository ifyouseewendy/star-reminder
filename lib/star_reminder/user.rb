# frozen_string_literal: true
class User < Model
  attribute :email
  unique :email
  index :email

  collection :following, :GithubUser

  def follow(github_user)
    return if followed? github_user
    github_user.user = self
    github_user.save
  end

  def followed?(github_user)
    following.include? github_user
  end

  # TODO: unfollow
end
