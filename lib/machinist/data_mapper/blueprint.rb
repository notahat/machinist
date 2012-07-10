module Machinist::DataMapper
  class Blueprint < Machinist::Blueprint

    # Make and save an object.
    def make!(attributes = {})
      object = make(attributes)
      if object.save
        object.reload
      else
        raise "#{object.class.name} is not valid"
      end
    end

    def lathe_class #:nodoc:
      Machinist::DataMapper::Lathe
    end

  end
end
