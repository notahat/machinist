require 'dm-core'
require 'machinist'
require 'machinist/data_mapper/blueprint'
require 'machinist/data_mapper/lathe'

module Machinist::DataMapperExtensions
  def blueprint_class
    Machinist::DataMapper::Blueprint
  end
end

DataMapper::Model.append_extensions(Machinist::Machinable)
DataMapper::Model.append_extensions(Machinist::DataMapperExtensions)
