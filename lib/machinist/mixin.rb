module Machinist
  module Mixin

    def blueprint(&block)
      if block_given?
        @blueprint = Machinist::Blueprint.new(:class => self, &block)
      else
        @blueprint
      end
    end

    def make(attributes = {})
      @blueprint.make(attributes)
    end

  end
end
