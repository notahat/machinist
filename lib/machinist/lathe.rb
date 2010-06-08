module Machinist
  class Lathe

    def initialize(object, attributes = {})
      @object = object
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

    def method_missing(symbol, *args) #:nodoc:
      if attribute_assigned?(symbol)
        @object.send(symbol)
      elsif block_given?
        assign_attribute(symbol, yield)
      else
        # FIXME: Raise a better exception.
        raise "Attribute not assigned."
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

  end
end
