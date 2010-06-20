module Machinist

  # Machinist extends classes with this module to define the `blueprint` and `make` methods.
  module Machinable
    # Define a blueprint with the given name for this class.
    #
    # e.g.
    #   Post.blueprint do
    #     title { "A Post" }
    #     body  { "Lorem ipsum..." }
    #   end
    #
    # If you provide the +name+ argument, a named blueprint will be created.
    # See the +blueprint_name+ argument to the make method.
    def blueprint(name = :master, &block)
      @blueprints ||= {}
      parent = @blueprints[:master] unless name == :master
      @blueprints[name] = blueprint_class.new(self, :parent => parent, &block)
    end

    # :call-seq:
    #   make([count], [blueprint_name], [attributes = {}])
    #
    # Construct an object from a blueprint. All arguments are optional.
    #
    # [+count+]
    #   The number of objects to construct. If +count+ is provided, make
    #   returns an array of objects rather than a single object.
    # [+blueprint_name+]
    #   Construct the object from the named blueprint, rather than the master
    #   blueprint.
    # [+attributes+]
    #   Override the attributes from the blueprint with values from this hash.
    def make(*args)
      decode_args_to_make(*args) do |blueprint, attributes|
        blueprint.make(attributes)
      end
    end

    # Construct and save an object from a blueprint, if the class allows saving.
    #
    # A matching object will be returned from the shop if possible. See
    # Machinist::Shop.
    #
    # Arguments are the same as for make.
    def make!(*args)
      decode_args_to_make(*args) do |blueprint, attributes|
        Shop.buy(blueprint, attributes)
      end
    end

    # Remove all blueprints defined on this class.
    def clear_blueprints!
      @blueprints = {}
    end

    # Classes that include Machinable can override this method if they want to
    # use a custom blueprint class when constructing blueprints.
    #
    # The default is Machinist::Blueprint.
    def blueprint_class
      Machinist::Blueprint
    end

  private

    def decode_args_to_make(*args)
      shift_arg = lambda {|klass| args.shift if args.first.is_a?(klass) }
      count      = shift_arg[Fixnum]
      name       = shift_arg[Symbol] || :master
      attributes = shift_arg[Hash]   || {}
      raise ArgumentError unless args.empty?  # FIXME: Meaningful exception.

      @blueprints ||= {}
      blueprint = @blueprints[name]
      raise "No blueprint defined" unless blueprint

      if count.nil?
        yield(blueprint, attributes)
      else
        Array.new(count) { yield(blueprint, attributes) }
      end
    end

  end
end
