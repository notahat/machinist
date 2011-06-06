module Machinist::DataMapper
  class Blueprint < Machinist::Blueprint

    def make!(attributes = {})
      object = make(attributes)
      if object.save
        object.reload
      else
        raise Machinist::SaveFailedError.new(object)
      end
    end

    def lathe_class
      Machinist::DataMapper::Lathe
    end

  end
end
