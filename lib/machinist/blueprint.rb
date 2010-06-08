module Machinist
  class Blueprint

    def initialize(klass = OpenStruct, &block)
      @klass = klass
      @block = block
    end

    def make(attributes = {})
      lathe = Lathe.new(@klass.new, attributes)
      lathe.instance_eval(&@block)
      block_given? ? yield(lathe.object) : lathe.object
    end

  end
end
