# frozen_string_literal: true
require "test_helper"

describe GithubStar do
  let(:username) { "di" }
  let(:github_user) { GithubUser.with(:username, username) }
  let(:github_star) { GithubStar.find(user_id: github_user.id).first }

  before do
    GithubUser.create(username: username)
    GithubStar.create(user: github_user)
  end

  after do
    [GithubUser, GithubStar].each { |m| m.all.each(&:delete) }
  end

  it "should reference to a user" do
    assert_equal github_user.id, github_star.user.id
  end
end
