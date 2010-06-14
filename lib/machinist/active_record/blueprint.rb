module Machinist::ActiveRecord

  class Blueprint < Machinist::Blueprint
    def make!(attributes = {})
      object = make(attributes)
      object.save!
      object.reload
    end
  end

end
