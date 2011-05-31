require 'dm-core'
require 'machinist'

module Machinist::DataMapper

  class Blueprint < Machinist::Blueprint

    def make!(attributes = {})
      object = make(attributes)
      if object.save
        object.reload
      else
        raise ArgumentError, "Error creating object: #{ object.errors.full_messages.inspect }"
      end
    end

    def box(object)
      object.id
    end

    def unbox(id)
      @class.get(id)
    end

    def outside_transaction
      raise NotImplementedError, 'Disable object caching'
    end

    def lathe_class
      Machinist::DataMapper::Lathe
    end

  end

  class Lathe < Machinist::Lathe

    def make_one_value(attribute, args)
      if block_given?
        raise_argument_error(attribute) unless args.empty?
        yield
      else # make an association
        association = @klass.relationships[attribute.to_s]
        raise_argument_error(attribute) unless association
        association_klass = association.parent_model == @klass ? association.child_model : association.parent_model
        association_klass.make(*args)
      end
    end

  end

end

module Machinist::DataMapper::Extension
  def blueprint_class
    Machinist::DataMapper::Blueprint
  end
end

DataMapper::Model.append_extensions(Machinist::Machinable, Machinist::DataMapper::Extension)
