require 'ostruct'

module Machinist
  class Blueprint

    def initialize(klass = OpenStruct, &block)
      @klass = klass
      @block = block
    end

    attr_reader :klass

    def make(attributes = {})
      lathe = Lathe.new(@klass.new, new_serial_number, attributes)
      lathe.instance_eval(&@block)
      lathe.object.save! if lathe.object.respond_to?(:save!) # FIXME: This is a hack.
      block_given? ? yield(lathe.object) : lathe.object
    end

  private
  
    def new_serial_number
      @serial_number ||= 0
      @serial_number += 1
      sprintf("%04d", @serial_number)
    end

  end
end
