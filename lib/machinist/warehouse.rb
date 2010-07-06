module Machinist

  # A Warehouse is a hash supports lists as keys.
  #
  # It's used for storing cached objects created by Machinist::Shop.
  #
  #     warehouse[1, 2] = "Hello, world!"
  #     warehouse[1, 2] # => "Hello, world!"
  class Warehouse < Hash

    # Assign a value for the given list of keys.
    def []=(*keys)
      value = keys.pop
      super(keys, value)
    end

    # Return the value for the given list of keys.
    #
    # If the list of keys doesn't exist in the hash, this assigns a new empty
    # array to that list of keys.
    def [](*keys)
      self[*keys] = [] if !has_key?(keys)
      super(keys)
    end

    # Return a new warehouse with the same keys, and dups of all the values.
    def clone
      clone = Warehouse.new
      each_pair do |key, value|
        clone[*key] = value.dup
      end
      clone
    end

  end
end
