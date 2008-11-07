require 'active_support'

class Sham
  @@shams = {}
  
  # Over-ride module's built-in name method, so we can re-use it for
  # generating names. This is a bit of a no-no, but we get away with
  # it in this context.
  def self.name(*args, &block)
    method_missing(:name, *args, &block)
  end
  
  def self.method_missing(symbol, *args, &block)
    if block_given?
      @@shams[symbol] = Sham.new(symbol, args.pop || {}, &block)
    else
      sham = @@shams[symbol]
      raise "No sham defined for #{symbol}" if sham.nil?
      sham.fetch_value
    end
  end

  def self.reset
    @@shams.values.each(&:reset)
  end
  
  def initialize(name, options = {}, &block)
    @name      = name
    @generator = block
    @offset    = 0
    @unique    = options.has_key?(:unique) ? options[:unique] : true
    generate_values(12)
  end
  
  def reset
    @offset = 0
  end
  
  def fetch_value
    # Generate more values if we need them.
    if @offset >= @values.length
      generate_values(2 * @values.length)
      raise "Can't generate more unique values for Sham.#{@name}" if @offset >= @values.length
    end
    returning @values[@offset] do
      @offset += 1
    end
  end
    
private
  
  def generate_values(count)
    @values = seeded { (1..count).map(&@generator) }
    @values.uniq! if @unique
  end
  
  def seeded
    begin
      srand(1)
      yield
    ensure
      srand
    end
  end
end
