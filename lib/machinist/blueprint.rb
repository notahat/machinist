module Machinist
  class Blueprint

    # FIXME: More docs here.
    #
    # The :parent option can be another Blueprint, or a class in which to look for a blueprint.
    # In the latter case, make will walk up the class tree looking for blueprints to apply.
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
      if parent_blueprint 
        parent_blueprint.new_serial_number
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
      ancestor = parent_blueprint
      while ancestor
        yield ancestor
        ancestor = ancestor.parent_blueprint
      end
    end

    def parent_blueprint
      case @parent
        when nil
          nil
        when Blueprint
          @parent
        else
          # @parent is a class in which we should look for a blueprint.
          klass = @parent
          until has_blueprint?(klass) || klass.nil?
            klass = klass.superclass
          end
          klass && klass.blueprint
      end
    end

    def has_blueprint?(klass)
      klass.respond_to?(:blueprint) && !klass.blueprint.nil?
    end

  end
end
