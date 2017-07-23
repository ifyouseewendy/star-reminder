# frozen_string_literal: true
require "test_helper"

describe StarReminder do
  let(:subject) { StarReminder }

  it ".env should return the current env" do
    assert_equal :test, subject.env
  end

  it ".env? should have a predict on env" do
    assert subject.test?
    refute subject.production?
  end

  it ".root should return the project root" do
    assert_equal File.expand_path("../..", __FILE__), subject.root.to_s
  end
end
