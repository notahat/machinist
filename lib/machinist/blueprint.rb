require 'ostruct'

module Machinist
  class Blueprint

    def initialize(options = {}, &block)
      @klass  = options[:class] || OpenStruct
      @parent = options[:parent]
      @block  = block
    end

    attr_reader :klass, :parent, :block

    def make(attributes = {})
      lathe = Lathe.new(@klass.new, new_serial_number, attributes)

      lathe.instance_eval(&@block)
      each_ancestor {|blueprint| lathe.instance_eval(&blueprint.block) }
      object = lathe.object

      object.save! if object.respond_to?(:save!) # FIXME: This is a hack.

      block_given? ? yield(object) : object
    end

    def new_serial_number
      if @parent
        @parent.new_serial_number
      else
        @serial_number ||= 0
        @serial_number += 1
        sprintf("%04d", @serial_number)
      end
    end

  private

    def each_ancestor
      ancestor = @parent
      while ancestor
        yield ancestor
        ancestor = ancestor.parent
      end
    end

  end
end
