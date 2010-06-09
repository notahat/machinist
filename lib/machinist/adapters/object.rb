require 'machinist'

module Machinist
  module Adapters
    module Object
    
      def self.can_cache?
        false
      end
      
    end
  end
end

class Object #:nodoc:
  include Machinist::Machinable
  
  def self.machinist_adapter
    Machinist::Adapters::Object
  end
end
