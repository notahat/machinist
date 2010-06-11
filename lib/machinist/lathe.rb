require 'active_support/inflector'

module Machinist
  class Lathe

    def initialize(object, serial_number, attributes = {})
      @object        = object
      @serial_number = serial_number
      attributes.each {|key, value| assign_attribute(key, value) }
    end

    # Call this from within a blueprint to get at the object being constructed.
    #
    # e.g.
    #   Post.blueprint do
    #     title { "A Title" }
    #     body  { object.title.downcase }
    #   end
    def object
      yield @object if block_given?
      @object
    end

    # Provide a serial number to uniquely identify the object being constructed.
    attr_reader :serial_number
    alias_method :sn, :serial_number

    def method_missing(symbol, *args, &block) #:nodoc:
      if attribute_assigned?(symbol)
        @object.send(symbol)
      else
        generate_attribute(symbol, *args, &block)
      end
    end

  private
    
    def assigned_attributes
      @assigned_attributes ||= {}
    end
    
    def assign_attribute(key, value)
      assigned_attributes[key.to_sym] = value
      @object.send("#{key}=", value)
    end
  
    def attribute_assigned?(key)
      assigned_attributes.has_key?(key.to_sym)
    end

    def generate_attribute(attribute, *args)
      value = if block_given?
        yield
      else
        klass = class_for_singular_attribute(attribute) ||
                class_for_plural_attribute(attribute)   ||
                raise("Can't find a class for the attribute: #{attribute}")
        klass.make(*args)
      end
      assign_attribute(attribute, value)
    end

    def class_for_singular_attribute(attribute)
      begin
        attribute.to_s.camelize.constantize
      rescue NameError
        nil
      end
    end

    def class_for_plural_attribute(attribute)
      begin
        attribute.to_s.camelize.singularize.constantize
      rescue NameError
        nil
      end
    end

  end
end
