require 'machinist/active_record/blueprint'

module Machinist::ActiveRecord
  class Adapter < Machinist::Adapter
 
    def blueprint_class
      Machinist::ActiveRecord::Blueprint
    end

    def outside_transaction
      thread = Thread.new do
        begin
          yield
        ensure
          ::ActiveRecord::Base.connection_pool.checkin(::ActiveRecord::Base.connection)
        end
      end
      thread.value
    end

    def serialize(object)
      object.id
    end
    
    def instantiate(klass, id)
      klass.find(id)
    end

  end
end
