module Machinist::ActiveRecord

  class Lathe < Machinist::Lathe

  protected

    def generate_value(attribute, *args, &block) #:nodoc:
      if block_given?
        raise ArgumentError unless args.empty?  # FIXME: Raise a better error.
        yield
      else
        generate_value_for_association(attribute, *args)
      end
    end

    def generate_value_for_association(attribute, *args) #:nodoc:
      association = @klass.reflect_on_association(attribute)
      if association
        association.klass.make(*args)
      else
        raise ArgumentError  # FIXME: Raise a better error.
      end
    end

  end
end
