module Machinist::Strategies

  def self.register(name, strategy)
    @strategies ||= {}
    @strategies[name] = strategy
  end

  def self.[](name)
    @strategies ||= {}
    @strategies[name]
  end

  # FIXME: Make this configurable.
  def self.default
    :assign_attributes
  end

end
