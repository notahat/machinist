module Machinist::Sequel
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
      association = @klass.association_reflection(attribute)
      if association
        association.associated_class.make(*args)
      else
        raise_argument_error(attribute)
      end
    end

    def assign_attribute(attribute, value)
      association = @klass.association_reflection(attribute)
      if association
        if association.returns_array?
          (object.machinist_deferred_associations ||= []) << [association, value]
        elsif value.new?
          value.save(:raise_on_failure => true)
          super
        end
      else
        super
      end
    end
  end
end
