module Machinist::ActiveRecord
  class Lathe < Machinist::Lathe

    def generate_value(attribute, *args, &block)
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
        raise ArgumentError unless args.empty?
        yield
      end
    end

  end
end
