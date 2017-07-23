# frozen_string_literal: true
require "test_helper"

describe GithubStar do
  let(:username) { "di" }
  let(:github_user) { GithubUser.with(:username, username) }
  let(:github_star) { GithubStar.find(user_id: github_user.id).first }
  let(:fixture) { JSON.parse(File.read("test/fixtures/star.json")).with_indifferent_access }

  before do
    GithubUser.find_or_create_by(username: username)
  end

  it "should reference to a user" do
    GithubStar.find_or_create_by(fixture, github_user)
    assert_equal github_user.id, github_star.user.id
  end

  describe ".find_or_create_by" do
    it "should create a star with user associated" do
      assert_equal 0, github_user.stars.count
      GithubStar.find_or_create_by(fixture, github_user)
      assert_equal 1, github_user.stars.count
    end

    it "should override the default one" do
      GithubStar.find_or_create_by(fixture, github_user)
      assert_equal 1, github_user.stars.count
      GithubStar.find_or_create_by(fixture, github_user)
      assert_equal 1, github_user.stars.count
    end
  end
end
