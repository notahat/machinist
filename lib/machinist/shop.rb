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

    # Make sure this gets called before each test to refill the shop with the
    # entire set of cached objects.
    def restock
      @back_room = @warehouse.clone
    end

    # When you request an object from the shop, it looks in the back room to
    # see if it has any objects that match what you're after.
    #
    # Objects are kept on shelves, where each shelf holds objects constructed
    # with a particular blueprint and set of attributes.
    #
    # If there's a matching object on the right shelf, it's pulled off the
    # shelf and sold to you.
    #
    # If there's no matching object, a new one is created (on a separate
    # database connection, so that it will stick around after your transaction
    # rolls back.)
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
