require 'active_support'
require 'active_record'
require 'sham'
require 'machinist/active_record'
 
module Machinist

  # A Lathe is used to execute the blueprint and construct an object.
  #
  # The blueprint is instance_eval'd against the Lathe.
  class Lathe
    def self.run(object, *args)
      blueprint       = object.class.blueprint
      named_blueprint = object.class.blueprint(args.shift) if args.first.is_a?(Symbol)
      attributes      = args.pop || {}
      raise "No blueprint for class #{object.class}" if blueprint.nil?
      returning self.new(object, attributes) do |lathe|
        lathe.instance_eval(&named_blueprint) if named_blueprint
        lathe.instance_eval(&blueprint)
      end
    end
    
    def initialize(object, attributes = {})
      @object = object
      attributes.each {|key, value| assign_attribute(key, value) }
    end

    def object
      yield @object if block_given?
      @object
    end
    
    def method_missing(symbol, *args, &block)
      if attribute_assigned?(symbol)
        # If we've already assigned the attribute, return that.
        @object.send(symbol)
      elsif @object.class.reflect_on_association(symbol) && !@object.send(symbol).nil?
        # If the attribute is an association and is already assigned, return that.
        @object.send(symbol)
      else
        # Otherwise generate a value and assign it.
        assign_attribute(symbol, generate_attribute_value(symbol, *args, &block))
      end
    end

    def assigned_attributes
      @assigned_attributes ||= {}
    end
    
    # Undef a couple of methods that are common ActiveRecord attributes.
    # (Both of these are deprecated in Ruby 1.8 anyway.)
    undef_method :id   if respond_to?(:id)
    undef_method :type if respond_to?(:type)
    
  private
    
    def assign_attribute(key, value)
      assigned_attributes[key.to_sym] = value
      @object.send("#{key}=", value)
    end
  
    def attribute_assigned?(key)
      assigned_attributes.has_key?(key.to_sym)
    end
    
    def generate_attribute_value(attribute, *args)
      value = if block_given?
        # If we've got a block, use that to generate the value.
        yield
      elsif !args.empty?
        # If we've got a constant, just use that.
        args.first
      else
        # Otherwise, look for an association or a sham.
        association = object.class.reflect_on_association(attribute)
        if association
          association.class_name.constantize.make(args.first || {})
        else
          Sham.send(attribute)
        end
      end
      assign_attribute(attribute, value)
    end
    
  end
end
