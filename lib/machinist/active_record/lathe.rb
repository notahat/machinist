module Machinist::ActiveRecord

  class Lathe < Machinist::Lathe

    def make_one_value(attribute, args) #:nodoc:
      if block_given?
        raise_argument_error(attribute) unless args.empty?
        yield
      else
        make_association(attribute, args)
      end
    end

    def make_association(attribute, args) #:nodoc:
      association = @klass.reflect_on_association(attribute)
      if association
        association.klass.make(*args)
      else
        raise_argument_error(attribute)
      end
    end

  end
end
