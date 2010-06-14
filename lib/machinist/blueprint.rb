module Machinist
  class Blueprint

    def initialize(klass, options = {}, &block)
      @klass  = klass
      @parent = options[:parent]
      @block  = block
    end

    attr_reader :klass, :parent, :block

    def make(attributes = {})
      lathe = lathe_class.new(@klass.new, new_serial_number, attributes)

      lathe.instance_eval(&@block)
      each_ancestor {|blueprint| lathe.instance_eval(&blueprint.block) }
      object = lathe.object

      object
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

  protected

    def lathe_class
      Lathe
    end

    def each_ancestor
      ancestor = @parent
      while ancestor
        yield ancestor
        ancestor = ancestor.parent
      end
    end

  end
end
