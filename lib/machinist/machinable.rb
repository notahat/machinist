module Machinist
  module Machinable

    def blueprint(name = :master, &block)
      @blueprints ||= {}
      parent = @blueprints[:master] unless name == :master
      @blueprints[name] = Machinist::Blueprint.new(:class => self, :parent => parent, &block)
    end

    def make(*args)
      count      = shift_arg(args, Fixnum)
      name       = shift_arg(args, Symbol) || :master
      attributes = shift_arg(args, Hash)   || {}
      raise ArgumentError unless args.empty?

      @blueprints ||= {}
      raise "No blueprint defined" unless @blueprints[name]
      if count.nil?
        Shop.buy(@blueprints[name], attributes)
      else
        Shop.buy_n(count, @blueprints[name], attributes)
      end
    end

    def clear_blueprints!
      @blueprints = nil
    end

  private

    def shift_arg(args, klass)
      args.shift if args.first.is_a?(klass)
    end

  end
end
