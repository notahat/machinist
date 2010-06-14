module Machinist
  module Machinable

    def blueprint(name = :master, &block)
      blueprint_class = machinist_adapter.blueprint_class

      @blueprints ||= {}
      parent = @blueprints[:master] unless name == :master
      @blueprints[name] = blueprint_class.new(self, :parent => parent, &block)
    end

    def make(*args)
      process(*args) do |blueprint, attributes|
        blueprint.make(attributes)
      end
    end

    def make!(*args)
      process(*args) do |blueprint, attributes|
        Shop.buy(blueprint, attributes)
      end
    end

    def clear_blueprints!
      @blueprints = {}
    end

    def machinist_adapter
      @machinist_adapter ||= Machinist::Adapter.new
    end

  private

    # FIXME: Needs a better name.
    def process(*args)
      count      = shift_arg(args, Fixnum)
      name       = shift_arg(args, Symbol) || :master
      attributes = shift_arg(args, Hash)   || {}
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

    def shift_arg(args, klass)
      args.shift if args.first.is_a?(klass)
    end

  end
end
