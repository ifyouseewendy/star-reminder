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

  it "should persist the record" do
    assert_equal 1, User.all.count
  end

  describe "callbacks" do
    it "should set a default digest count after create" do
      User::DEFAULT_SETTING.each do |k, v|
        assert_equal v, user.public_send(k)
      end
    end
  end

  describe "#to_s" do
    it "should show identifier" do
      assert_equal "User<di@example.com>", user.to_s
    end
  end

  describe "#follow" do
    it "should create an association" do
      assert user.following.count.zero?
      user.follow(github_user)
      assert_equal github_user.id, user.following.first.id
    end

    it "should be idempotent to follow a github_user" do
      assert user.follow(github_user)
      refute user.follow(github_user)
    end
  end

  describe "#send_digest" do
    let(:fixture) { JSON.parse(File.read("test/fixtures/star.json")).with_indifferent_access }
    let(:github_star) { GithubStar.find(user_id: github_user.id).first }

    before do
      user.follow(github_user)
      GithubStar.find_or_create_by(fixture, github_user)
    end

    it "should send digests using Mailer" do
      payload = [0] * 2
      user.stubs(:digest).returns(payload)
      user.stubs(:flag_sent).returns(nil)
      Mailer.expects(:welcome).with(to: user.email, payload: payload).returns(stub(deliver_now: nil))

      user.send_digest
    end

    it "should return if there are no digest to send" do
      user.stubs(:digest).returns([])
      refute user.send_digest
    end

    it "should flag the messages have been sent" do
      user.stubs(:digest).returns([github_star] * 2)
      Mailer.stubs(:welcome).returns(stub(deliver_now: nil))

      assert_equal 0, user.sent.count
      user.send_digest
      assert_equal github_star, user.sent.first
    end
  end

  describe "#digest" do
    let(:fixture) { JSON.parse(File.read("test/fixtures/star.json")).with_indifferent_access }
    let(:github_star) { GithubStar.find(user_id: github_user.id).first }

    before do
      user.follow(github_user)
      3.times do |i|
        new_star = fixture.merge(name: "fixture[:name]#{i}")
        GithubStar.find_or_create_by(new_star, github_user)
      end

      user.stubs(:fetch_stars).returns([0] * 5)
    end

    it "should randomly fetch stars for empty sent" do
      assert_empty user.sent
      assert_equal user.digest_count, user.digest.count
    end

    it "should fetch stars excluding sent" do
      fst, *snd = GithubStar.all.to_a
      user.sent.add fst
      assert_equal snd, user.digest.sort_by(&:id)
    end

    it "should refresh fetching when there are not enough stars to digest" do
      user.expects(:generate_digest).with(nil).returns([]).once
      user.expects(:generate_digest).with(refresh: true).returns([0] * 2).once
      assert_equal user.digest_count, user.digest.count
    end

    it "should return empty when there are not enough stars to digest even after refreshing" do
      user.expects(:generate_digest).with(nil).returns([]).once
      user.expects(:generate_digest).with(refresh: true).returns([0] * 1).once
      assert_equal [], user.digest
    end

    it "should generate digests by user digest count" do
      user.stubs(:digest_count).returns(0)

      assert_empty user.digest
    end
  end
end
