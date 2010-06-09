require 'machinist/blueprints'

module Machinist
  module Adapters
    module Object
      
      def self.serialize(klass, object)
        object.dup
      end
      
      def self.instantiate(klass, object)
        object.dup
      end
      
      def self.outside_transaction
        yield
      end
      
    end
  end
end

class Object #:nodoc:
  include Machinist::Blueprints
  
  def self.machinist_adapter
    Machinist::Adapters::Object
  end
  
  def make(attributes = {}, &block)
    object = Machinist::Lathe.make(self, attributes)
    block_given? ? yield(object) : object
  end
end
