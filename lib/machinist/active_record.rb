require 'active_record'
require 'machinist'

module Machinist::ActiveRecord
  class Blueprint < Machinist::Blueprint

    def make!(attributes = {})
      object = make(attributes)
      object.save!
      object.reload
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
    
    def instantiate(id)
      @klass.find(id)
    end

  end
end

class ActiveRecord::Base #:nodoc:
  extend Machinist::Machinable

  def self.blueprint_class
    Machinist::ActiveRecord::Blueprint
  end
end
