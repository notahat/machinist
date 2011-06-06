module Machinist

  # Raised when make! is called on a class whose blueprints don't support
  # saving.
  class SaveFailedError < RuntimeError
    attr_reader :resource

    def initialize(resource)
      @resource = resource
    end

    def message
      "Error saving resource: #{@resource}. Errors: #{@resource.errors.inspect}"
    end
  end

  # Raised when make! is called on a class whose blueprints don't support
  # saving.
  class BlueprintCantSaveError < RuntimeError
    attr_reader :blueprint

    def initialize(blueprint)
      @blueprint = blueprint
    end

    def message
      "make! is not supported by blueprints for class #{@blueprint.klass.name}"
    end
  end

  # Raised when calling make on a class with no corresponding blueprint
  # defined.
  class NoBlueprintError < RuntimeError
    attr_reader :klass, :name

    def initialize(klass, name)
      @klass = klass
      @name  = name
    end

    def message
      "No #{@name} blueprint defined for class #{@klass.name}"
    end
  end

end
