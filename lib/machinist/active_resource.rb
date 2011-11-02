require 'active_resource'
require 'machinist'
require 'machinist/active_resource/blueprint'
require 'machinist/active_record/lathe'

module ActiveResource #:nodoc:
  class Base #:nodoc:
    extend Machinist::Machinable

    def self.blueprint_class
      Machinist::ActiveResource::Blueprint
    end
  end
end
