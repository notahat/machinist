module Machinist
  module Machinable
    def blueprint(name = :master, &block)
      @blueprints ||= {}
      parent = @blueprints[:master] unless name == :master
      @blueprints[name] = blueprint_class.new(self, :parent => parent, &block)
    end

    def make(*args)
      decode_args_to_make(*args) do |blueprint, attributes|
        blueprint.make(attributes)
      end
    end

    def make!(*args)
      decode_args_to_make(*args) do |blueprint, attributes|
        Shop.buy(blueprint, attributes)
      end
    end

    def clear_blueprints!
      @blueprints = {}
    end

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
