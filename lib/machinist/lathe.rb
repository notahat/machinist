require 'active_support/inflector'

module Machinist
  class Lathe

    def initialize(object, serial_number, attributes = {})
      @object              = object
      @serial_number       = serial_number
      @assigned_attributes = {}
      attributes.each {|key, value| assign_attribute(key, value) }
    end

    # Returns a unique serial number for the object under construction.
    attr_reader :serial_number
    alias_method :sn, :serial_number

    # Returns the object under construction.
    #
    # e.g.
    #   Post.blueprint do
    #     title { "A Title" }
    #     body  { object.title.downcase }
    #   end
    attr_reader :object

    def method_missing(symbol, *args, &block) #:nodoc:
      unless attribute_assigned?(symbol)
        assign_attribute(symbol, generate_attribute(symbol, *args, &block))
      end
    end

  protected

    def generate_attribute(symbol, *args, &block)
      count = args.shift if args.first.is_a?(Fixnum)
      if count
        Array.new(count) { generate_value(symbol, *args, &block) }
      else
        generate_value(symbol, *args, &block)
      end
    end

    def generate_value(symbol, *args, &block)
      raise ArgumentError unless args.empty?
      yield
    end
    
    def assign_attribute(key, value)
      @assigned_attributes[key.to_sym] = value
      @object.send("#{key}=", value)
    end
  
    def attribute_assigned?(key)
      @assigned_attributes.has_key?(key.to_sym)
    end

  end
end
