# frozen_string_literal: true
require "test_helper"

describe StarReminder do
  let(:subject) { StarReminder }

  it "should have an env" do
    assert_equal :test, subject.env
  end

  it "should have a predict on env" do
    assert subject.test?
    refute subject.production?
  end
end
