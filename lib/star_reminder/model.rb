# frozen_string_literal: true
class Model < Ohm::Model
  include Ohm::Timestamps
  include Ohm::DataTypes

  def self.find_or_create_by(*args)
    find(*args).first || create(*args)
  end

  def to_hash
    super.merge self.class.attributes.each_with_object({}) { |e, h| h[e] = public_send(e) }
  end

  alias_method :attributes, :to_hash
end
