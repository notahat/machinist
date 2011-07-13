require 'sequel'
require 'machinist'
require 'machinist/sequel/blueprint'
require 'machinist/sequel/lathe'

module Sequel #:nodoc:
  class Model #:nodoc:
    extend Machinist::Machinable

    def self.blueprint_class
      Machinist::Sequel::Blueprint
    end

    attr_accessor :machinist_deferred_associations
  end
end
