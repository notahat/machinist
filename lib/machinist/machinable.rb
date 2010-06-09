module Machinist
  module Machinable

    def blueprint(name = :master, &block)
      @blueprints ||= {}
      if block_given?
        parent = @blueprints[:master] unless name == :master
        @blueprints[name] = Machinist::Blueprint.new(:class => self, :parent => parent, &block)
      else
        @blueprints[name]
      end
    end

    def make(name = :master, attributes = {})
      @blueprints ||= {}
      raise "No blueprint defined" unless @blueprints[name]
      Machinist::Shop.buy(@blueprints[name], attributes)
    end

    def clear_blueprints!
      @blueprints = nil
    end

  end
end
