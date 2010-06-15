require 'machinist/lathe'

class Machinist::Collection
  class Lathe < Machinist::Lathe
    
    def method_missing(attribute, *args, &block) #:nodoc:
      if attribute_assigned?(attribute) && @object.send(attribute).is_a?(Array)
        unless args.empty?
          append_to_attribute(attribute, generate_attribute(attribute, *args, &block))
        end
      elsif !attribute_assigned?(attribute)
        value = generate_attribute(attribute, *args, &block)
        assign_attribute(attribute, value)
      end
      @object.send(attribute)
    end

  protected
    
    def append_to_attribute(attribute, value)
      assign_attribute(attribute, @object.send(attribute) + value)
    end

    def generate_value(attribute, *args, &block)
      if block_given?
        raise ArgumentError unless args.empty?  # FIXME: Raise a better error.
        yield
      else
        generate_value_from_attribute_name(attribute, *args)
      end
    end

    def generate_value_from_attribute_name(attribute, *args)
      klass = class_for_singular_attribute(attribute) ||
              class_for_plural_attribute(attribute)   ||
              raise("Can't find a class for the attribute: #{attribute}")
      klass.make!(*args)
    end

    def class_for_singular_attribute(attribute)
      class_for(attribute.to_s.camelize)
    end

    def class_for_plural_attribute(attribute)
      class_for(attribute.to_s.singularize.camelize)
    end

    def class_for(class_name)
      begin
        class_name.constantize
      rescue NameError
        nil
      end
    end

  end
end
