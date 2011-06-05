module Machinist::DataMapper
  class Blueprint < Machinist::Blueprint
    # Make and save an object.
    def make!(attributes = {})
      object = make(attributes)
      object.save && object
    end

    def lathe_class #:nodoc:
      Machinist::DataMapper::Lathe
    end
  end
end
