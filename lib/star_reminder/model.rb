# frozen_string_literal: true
class Model < Ohm::Model
  include Ohm::Timestamps
  include Ohm::DataTypes
  include Ohm::Callbacks

  def self.find_or_create_by(*args)
    find(*args).first || create(*args)
  end

  def self.find_all(query)
    raise "Not accept multiple query right now: #{query}" unless query.count == 1

    key, value = query.to_a.first
    values = Array.wrap(value)

    first, left = values[0], values[1..-1]

    left.reduce(find("#{key}": first)) do |a, e|
      a.union("#{key}": e)
    end
  end

  def to_hash
    super.merge self.class.attributes.each_with_object({}) { |e, h| h[e] = public_send(e) }
  end

  def logger
    @_logger ||= StarReminder.logger
  end

  def statsd
    @_statsd ||= StarReminder.statsd
  end

  alias_method :attributes, :to_hash
end
