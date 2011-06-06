require 'dm-core'
require 'machinist'
require 'machinist/datamapper/blueprint'
require 'machinist/datamapper/lathe'

module Machinist::DataMapper::Extension
  def blueprint_class
    Machinist::DataMapper::Blueprint
  end
end

DataMapper::Model.append_extensions(Machinist::Machinable, Machinist::DataMapper::Extension)
