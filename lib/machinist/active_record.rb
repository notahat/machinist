require 'active_record'
require 'machinist'
require 'machinist/active_record/blueprint'
require 'machinist/active_record/lathe'

module ActiveRecord #:nodoc:
  class Base #:nodoc:
    extend Machinist::Machinable

    def self.blueprint_class
      Machinist::ActiveRecord::Blueprint
    end
  end
end
