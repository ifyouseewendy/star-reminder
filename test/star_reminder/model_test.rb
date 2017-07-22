# frozen_string_literal: true
require "test_helper"

describe Model do
  class Dog < Model
    attribute :name
    index :name
    attribute :age, Type::Integer
  end

  let(:dog) { Dog.create(name: "Ruby", age: 3) }

  describe "extensions" do
    it "should have timestamps" do
      assert dog.created_at
    end

    it "should coerce data types" do
      assert_kind_of Integer, dog.age
    end
  end

  describe ".find_or_create_by" do
    it "should find an existent record" do
      assert dog.id, Dog.find_or_create_by(name: "Ruby")
    end

    it "should create a new record" do
      assert Dog.all.count.zero?
      Dog.find_or_create_by(name: "Rocky")
      assert_equal 1, Dog.all.count
    end
  end

  describe ".find_all" do
    it "should support a union query" do
      Dog.create(name: "Ruby", age: 2)
      assert_equal 1, Dog.find_all(name: "Ruby").count

      Dog.create(name: "Rocky", age: 2)
      assert_equal 2, Dog.find_all(name: ["Ruby", "Rocky"]).count
    end
  end

  describe "#attributes" do
    it "should display all the attributes" do
      assert_includes dog.attributes.keys, :id
      assert_includes dog.attributes.keys, :name
    end
  end
end
