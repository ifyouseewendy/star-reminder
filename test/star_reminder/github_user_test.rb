# frozen_string_literal: true
require "test_helper"

describe GithubUser do
  let(:email) { "di@example.com" }
  let(:user) { User.with(:email, email) }
  let(:username) { "di" }
  let(:github_user) { GithubUser.with(:username, username) }

  before do
    User.create(email: email)
    GithubUser.create(username: username)
  end

  after do
    [User, GithubUser, GithubStar].each { |m| m.all.each(&:delete) }
  end

  it "should reference to a user" do
    refute github_user.user
    user.follow(github_user)
    assert_equal user.id, github_user.user.id
  end

  it "should have a collection of stars" do
    assert github_user.stars.count.zero?
    GithubStar.create(user: github_user)
    assert_equal 1, github_user.stars.count
  end

  describe "#fetch_stars" do
    it "should request Github API" do
      Octokit.expects(:starred).returns([])

      github_user.fetch_stars
    end
  end
end
