require 'machinist'
require 'machinist/blueprints'
require 'dm-core'

module Machinist
  
  class DataMapperAdapter
    def self.has_association?(object, attribute)
      object.class.relationships.has_key?(attribute)
    end
    
    def self.class_for_association(object, attribute)
      association = object.class.relationships[attribute]
      association && association.parent_model
    end
  end

  module DataMapperExtensions
    def make(*args, &block)
      lathe = Lathe.run(Machinist::DataMapperAdapter, self.new, *args)
      unless Machinist.nerfed?
        lathe.object.save || raise("Save failed")
        lathe.object.reload
      end
      lathe.object(&block)
    end

    def make_unsaved(*args)
      returning(Machinist.with_save_nerfed { make(*args) }) do |object|
        yield object if block_given?
      end
    end
  end

end

DataMapper::Model.append_extensions(Machinist::Blueprints::ClassMethods)
DataMapper::Model.append_extensions(Machinist::DataMapperExtensions)
