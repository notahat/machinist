require 'active_support/inflector'

module Machinist

  # When you make an object, the blueprint for that object is instance-evaled
  # against a Lathe.
  #
  # The Lathe implements all the methods that are available to the blueprint,
  # including method_missing to let the blueprint define attributes.
  class Lathe

    def initialize(klass, serial_number, attributes = {})
      @klass               = klass
      @serial_number       = serial_number
      @assigned_attributes = {}

      @object              = @klass.new
      attributes.each {|key, value| assign_attribute(key, value) }
    end

    # Returns a unique serial number for the object under construction.
    attr_reader :serial_number
    alias_method :sn, :serial_number

    # Returns the object under construction.
    attr_reader :object

    def method_missing(attribute, *args, &block) #:nodoc:
      unless attribute_assigned?(attribute)
        assign_attribute(attribute, make_attribute(attribute, args, &block))
      end
    end

    # Undef a couple of methods that are common ActiveRecord attributes.
    # (Both of these are deprecated in Ruby 1.8 anyway.)
    undef_method :id   if respond_to?(:id)
    undef_method :type if respond_to?(:type)

  protected

    def make_attribute(attribute, args, &block) #:nodoc:
      count = args.shift if args.first.is_a?(Fixnum)
      if count
        Array.new(count) { make_one_value(attribute, args, &block) }
      else
        make_one_value(attribute, args, &block)
      end
    end

    def make_one_value(attribute, args) #:nodoc:
      raise_argument_error(attribute) unless args.empty?
      yield
    end
    
    def assign_attribute(key, value) #:nodoc:
      @assigned_attributes[key.to_sym] = value
      @object.send("#{key}=", value)
    end
  
    def attribute_assigned?(key) #:nodoc:
      @assigned_attributes.has_key?(key.to_sym)
    end

    def raise_argument_error(attribute) #:nodoc:
      raise ArgumentError.new("Invalid arguments to attribute #{attribute} in blueprint") 
    end

  end
end
