require 'dm-core'
require 'machinist'
require 'machinist/data_mapper/blueprint'
require 'machinist/data_mapper/lathe'

module Machinist::DataMapper
  module BlueprintExtension
    def blueprint_class
      Machinist::DataMapper::Blueprint
    end
  end 
end

DataMapper::Model.append_extensions(Machinist::Machinable, Machinist::DataMapper::BlueprintExtension)
