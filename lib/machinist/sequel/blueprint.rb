module Machinist::Sequel
  class Blueprint < Machinist::Blueprint
    # Make and save an object.
    def make!(attributes = {})
      object = make(attributes)
      object.save(:raise_on_failure => true)

      deferred_associations = object.machinist_deferred_associations
      if deferred_associations
        deferred_associations.each do |association, array|
          array.each {|e| object.send(association.add_method, e) }
        end
      end

      object
    end

    def lathe_class #:nodoc:
      Machinist::Sequel::Lathe
    end
  end
end
