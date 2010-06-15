module Machinist::ActiveRecord
  class Lathe < Machinist::Lathe

    def generate_value(attribute, *args, &block)
      if block_given?
        raise ArgumentError unless args.empty?  # FIXME: Raise a better error.
        yield
      else
        generate_value_for_association(attribute, *args)
      end
    end

    def generate_value_for_association(attribute, *args)
      association = @object.class.reflect_on_association(attribute)
      if association
        case association.macro
          when :belongs_to
            association.klass.make!(*args)
          when :has_many
            association.klass.make(*args)
          else
            raise "Sorry, Machinist doesn't support #{association.macro} associations."
        end
      else
        raise ArgumentError  # FIXME: Raise a better error.
      end
    end

  end
end
