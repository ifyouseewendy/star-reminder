# frozen_string_literal: true
require "test_helper"

describe GithubStar do
  let(:username) { "di" }
  let(:github_user) { GithubUser.with(:username, username) }
  let(:github_star) { GithubStar.find(user_id: github_user.id).first }
  let(:fixture) { JSON.parse(File.read("test/fixtures/star.json")).with_indifferent_access }

  before do
    GithubUser.find_or_create_by(username: username)
    GithubStar.create_by(fixture, github_user)
  end

  it "should reference to a user" do
    assert_equal github_user.id, github_star.user.id
  end
end
