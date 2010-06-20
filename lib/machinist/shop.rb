module Machinist
  class Shop

    class << self
      def instance
        @instance ||= Shop.new
      end

      def buy(*args)
        instance.buy(*args)
      end

      def restock
        instance.restock
      end

      def reset!
        instance.reset!
      end
    end
    
    def initialize
      reset!
    end
    
    def reset!
      @warehouse = Warehouse.new
      restock
    end

    def restock
      @back_room = @warehouse.clone
    end

    def buy(blueprint, attributes = {})
      shelf = @back_room[blueprint, attributes]
      if shelf.empty?
        object = blueprint.outside_transaction { blueprint.make!(attributes) }
        @warehouse[blueprint, attributes] << blueprint.serialize(object)
        object
      else
        blueprint.instantiate(shelf.shift)
      end
    end

  end
end
