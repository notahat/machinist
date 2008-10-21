module Sham
  @@values     = {}
  @@offsets    = {}
  @@generators = {}
  
  # Over-ride module's built-in name method, so we can re-use it for
  # generating names. This is a bit of a no-no, but we get away with
  # it in this context.
  def self.name(*args, &block)
    method_missing(:name, *args, &block)
  end
  
  def self.method_missing(symbol, *args, &block)
    if block_given?
      @@generators[symbol] = block
      @@values[symbol] = generate_values(12, &block)
    else
      fetch_value(symbol)
    end
  end

  def self.reset
    @@offsets = {}
  end
  
private

  def self.fetch_value(symbol)
    offset = @@offsets[symbol] || 0
    @@offsets[symbol] = offset + 1
    if offset >= @@values[symbol].length
      @@values[symbol] = generate_values(2 * @@values[symbol].length, &@@generators[symbol])
    end
    @@values[symbol][offset]
  end
  
  def self.generate_values(count)
    seeded do
      (1..count).inject([]) do |values, index|
        value = yield
        value = yield while values.include?(value) # Make sure it's not a duplicate.
        values << value
      end
    end
  end
  
  def self.seeded
    old_seed = srand(1)
    result = yield
    srand(old_seed)
    result
  end
end
