module Machinist::ActiveRecord
  class Blueprint < Machinist::Blueprint

    # Make and save an object.
    def make!(attributes = {})
      object = make(attributes)
      object.save!
      object.reload
    end

    def lathe_class #:nodoc:
      Machinist::ActiveRecord::Lathe
    end

  end
end
