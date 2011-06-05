require 'dm-core'
require 'machinist'
require 'machinist/data_mapper/blueprint'
require 'machinist/data_mapper/lathe'

module DataMapper::Resource #:nodoc:
  # FIXME: Maybe there's a better way to override the mixin post-include logic?
  class << self
    alias_method :old_included, :included
    
    def included(resource)
      old_included(resource)
      resource.extend Machinist::Machinable
      
      class << resource
        def blueprint_class
          Machinist::DataMapper::Blueprint
        end
      end
    end
  end
end
