module Machinist
  class Shop

    def self.instance
      @instance ||= Shop.new
    end

    def self.buy(*args)
      instance.buy(*args)
    end
    
    def self.buy_n(*args)
      instance.buy_n(*args)
    end
    
    def initialize
      reset_warehouse
    end
    
    def reset_warehouse
      @warehouse = Warehouse.new
      reset
    end

    def reset
      @back_room = @warehouse.clone
    end

    def buy(blueprint, attributes = {})
      klass   = blueprint.klass
      adapter = klass.machinist_adapter rescue nil

      if adapter && adapter.can_cache?
        shelf = @back_room[blueprint, attributes]
        if shelf.empty?
          item = adapter.outside_transaction { blueprint.make(attributes) }
          @warehouse[blueprint, attributes] << adapter.serialize(klass, item)
          item
        else
          adapter.instantiate(klass, shelf.shift)
        end
      else
        blueprint.make(attributes)
      end 
    end

    def buy_n(count, blueprint, attributes = {})
      Array.new(count) { buy(blueprint, attributes) }
    end

  end
end
