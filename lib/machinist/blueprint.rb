module Machinist

  # A Blueprint defines a method of constructing objects of a particular class.
  class Blueprint

    # Construct a blueprint for the given +klass+.
    #
    # Pass in the +:parent+ option do define a parent blueprint to apply after
    # this one.  You can supply another blueprint, or a class in which to look
    # for a blueprint.  In the latter case, make will walk up the superclass
    # chain looking for blueprints to apply.
    def initialize(klass, options = {}, &block)
      @klass  = klass
      @parent = options[:parent]
      @block  = block
    end

    attr_reader :klass, :parent, :block

    # Generate an object from this blueprint.
    #
    # Pass in attributes to override values defined in the blueprint.
    def make(attributes = {})
      lathe = lathe_class.new(@klass, new_serial_number, attributes)

      lathe.instance_eval(&@block)
      each_ancestor {|blueprint| lathe.instance_eval(&blueprint.block) }

      lathe.object
    end

    # Returns the Lathe class used to make objects for this blueprint.
    #
    # Subclasses can override this to substitute a custom lathe class.
    def lathe_class
      Lathe
    end

    # Returns the parent blueprint for this blueprint.
    def parent_blueprint
      case @parent
        when nil
          nil
        when Blueprint
          # @parent references the parent blueprint directly.
          @parent
        else
          # @parent is a class in which we should look for a blueprint.
          find_blueprint_in_superclass_chain(@parent)
      end
    end
    
    # Yields the parent blueprint, its parent blueprint, etc.
    def each_ancestor
      ancestor = parent_blueprint
      while ancestor
        yield ancestor
        ancestor = ancestor.parent_blueprint
      end
    end

  protected

    def new_serial_number  #:nodoc:
      parent_blueprint = self.parent_blueprint  # Cache this for speed.
      if parent_blueprint
        parent_blueprint.new_serial_number
      else
        @serial_number ||= 0
        @serial_number += 1
        sprintf("%04d", @serial_number)
      end
    end

  private

    def find_blueprint_in_superclass_chain(klass)
      until has_blueprint?(klass) || klass.nil?
        klass = klass.superclass
      end
      klass && klass.blueprint
    end

    def has_blueprint?(klass)
      klass.respond_to?(:blueprint) && !klass.blueprint.nil?
    end

  end
end
