module Machinist

  # A Warehouse is just a hash that makes it easy to key off arrays of objects.
  #
  # For example, if you assign:
  #
  #     warehouse[1, 2] = "Hello, world!"
  #
  # then:
  #
  #     warehouse.has_key?([1, 2])
  #
  # will be true, and:
  #
  #     warehouse[1, 2]
  #
  # will return "Hello, world!"
  class Warehouse < Hash

    # Return a new warehouse with the same keys, and dups of all the values.
    def clone
      clone = Warehouse.new
      each_pair do |key, value|
        clone[*key] = value.dup
      end
      clone
    end

    # Assign a value for the given list of keys.
    def []=(*keys)
      value = keys.pop
      super(keys, value)
    end

    # Return the value for the given list of keys.
    def [](*keys)
      self[*keys] = [] if !has_key?(keys)
      super(keys)
    end

  end
end
