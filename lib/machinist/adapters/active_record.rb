require 'active_record'

module Machinist
  module Adapters
    module ActiveRecord
      
      def self.serialize(klass, object)
        object.id
      end
      
      def self.instantiate(klass, id)
        klass.find(id)
      end
      
      def self.outside_transaction
        thread = Thread.new do
          begin
            yield
          ensure
            ::ActiveRecord::Base.connection_pool.checkin(::ActiveRecord::Base.connection)
          end
        end
        thread.value
      end
      
    end
  end
end

class ActiveRecord::Base #:nodoc:
  extend Machinist::Machinable

  def self.machinist_adapter
    Machinist::Adapters::ActiveRecord
  end
end
