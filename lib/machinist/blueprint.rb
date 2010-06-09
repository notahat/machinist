require 'ostruct'

module Machinist
  class Blueprint

    def initialize(klass = OpenStruct, &block)
      @klass = klass
      @block = block
    end

    attr_reader :klass

    def make(attributes = {})
      lathe = Lathe.new(@klass.new, attributes)
      lathe.instance_eval(&@block)
      lathe.object.save! if lathe.object.respond_to?(:save!) # FIXME: This is a hack.
      block_given? ? yield(lathe.object) : lathe.object
    end

  end
end
