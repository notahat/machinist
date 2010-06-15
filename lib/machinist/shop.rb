module Machinist
  class Shop

    def self.instance
      @instance ||= Shop.new
    end

    def self.buy(*args)
      instance.buy(*args)
    end

    def self.reset_warehouse!
      instance.reset_warehouse!
    end

    def self.reset
      instance.reset
    end
    
    def initialize
      reset_warehouse!
    end
    
    def reset_warehouse!
      @warehouse = Warehouse.new
      reset
    end

    def reset
      @back_room = @warehouse.clone
    end

    def buy(blueprint, attributes = {})
      klass = blueprint.klass

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
