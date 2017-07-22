# frozen_string_literal: true
require "test_helper"

describe User do
  let(:email) { "di@example.com" }
  let(:user) { User.with(:email, email) }
  let(:username) { "di" }
  let(:github_user) { GithubUser.with(:username, username) }

  before do
    User.create(email: email)
    GithubUser.create(username: username)
  end

  after do
    [User, GithubUser].each { |m| m.all.each(&:delete) }
  end

  it "should persist the record" do
    assert_equal 1, User.all.count
  end

  describe "#follow" do
    it "should create an association" do
      assert user.following.count.zero?
      user.follow(github_user)
      assert_equal github_user.id, user.following.first.id
    end

    it "should return if there exists an association" do
      assert user.follow(github_user)
      refute user.follow(github_user)
    end
  end
end
