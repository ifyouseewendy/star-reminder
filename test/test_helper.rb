# frozen_string_literal: true
ENV["RACK_ENV"] = "test"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "star_reminder"

require "minitest/autorun"
require "minitest/spec"
require "mocha/mini_test"

Minitest::Test.class_eval do
  def teardown
    Ohm.flush
    super
  end
end
