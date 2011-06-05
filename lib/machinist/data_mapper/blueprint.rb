module Machinist::DataMapper
  class Blueprint < Machinist::Blueprint
    # Make and save an object.
    def make!(attributes = {})
      object = make(attributes)
      object.raise_on_save_failure = true
      object.save && object.reload
    end

    def lathe_class #:nodoc:
      Machinist::DataMapper::Lathe
    end
  end
end
