module Machinist

  # The shop takes care of caching database objects.
  #
  # Calling make! on a class requests objects from the shop; you don't
  # normally access the shop directly.
  #
  # Read more about object caching on the
  # wiki[http://wiki.github.com/notahat/machinist/object-caching].
  class Shop

    # Return the singleton Shop instance.
    def self.instance
      @instance ||= Shop.new
    end

    def initialize #:nodoc:
      reset!
    end
   
    # Throw out the entire collection of cached objects.
    def reset!
      @warehouse = Warehouse.new
      restock
    end

    # Restock the shop with all the cached objects we've got.
    #
    # This should be called before each test.
    def restock
      @back_room = @warehouse.clone
    end

    # Buy a (possibly cached) object from the shop.
    #
    # This is just like constructing an object by calling Blueprint#make!,
    # but it will return a previously cached object if one is available.
    def buy(blueprint, attributes = {})
      raise BlueprintCantSaveError.new(blueprint) unless blueprint.respond_to?(:make!)

      shelf = @back_room[blueprint, attributes]
      if shelf.empty?
        object = blueprint.outside_transaction { blueprint.make!(attributes) }
        @warehouse[blueprint, attributes] << blueprint.box(object)
        object
      else
        blueprint.unbox(shelf.shift)
      end
    end

  end
end
