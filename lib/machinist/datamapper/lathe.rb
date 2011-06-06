module Machinist::DataMapper

  class Lathe < Machinist::Lathe

    def make_one_value(attribute, args)
      if block_given?
        raise_argument_error(attribute) unless args.empty?
        yield
      else # make an association
        make_association(attribute, args)
      end
    end

    def make_association(attribute, args)
      association = @klass.relationships[attribute.to_s]

      if association
        association.target_model.make(*args)
      else
        raise_argument_error(attribute)
      end
    end

  end

end
