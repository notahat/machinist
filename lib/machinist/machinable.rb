module Machinist

  # Extend classes with this module to define the blueprint and make methods.
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
      if block_given?
        parent = (name == :master ? superclass : self) # Where should we look for the parent blueprint?
        @blueprints[name] = blueprint_class.new(self, :parent => parent, &block)
      end
      @blueprints[name]
    end

    # Construct an object from a blueprint.
    #
    # :call-seq:
    #   make([count], [blueprint_name], [attributes = {}])
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
    # :call-seq:
    #   make!([count], [blueprint_name], [attributes = {}])
    #
    # A cached object will be returned from the shop if possible. See
    # Machinist::Shop.
    #
    # Arguments are the same as for make.
    def make!(*args)
      decode_args_to_make(*args) do |blueprint, attributes|
        if Machinist.configuration.cache_objects?
          Shop.instance.buy(blueprint, attributes)
        else
          blueprint.make!(attributes)
        end
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

    # Parses the arguments to make.
    #
    # Yields a blueprint and an attributes hash to the block, which should
    # construct an object from them. The block may be called multiple times to
    # construct multiple objects.
    def decode_args_to_make(*args) #:nodoc:
      shift_arg = lambda {|klass| args.shift if args.first.is_a?(klass) }
      count      = shift_arg[Fixnum]
      name       = shift_arg[Symbol] || :master
      attributes = shift_arg[Hash]   || {}
      raise ArgumentError.new("Couldn't understand arguments") unless args.empty?

      @blueprints ||= {}
      blueprint = @blueprints[name]
      raise NoBlueprintError.new(self, name) unless blueprint

      if count.nil?
        yield(blueprint, attributes)
      else
        Array.new(count) { yield(blueprint, attributes) }
      end
    end

  end
end
