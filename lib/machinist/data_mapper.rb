require 'dm-core'

module Machinist
  module DataMapperExtensions
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
      def make(*args, &block)
        lathe = Lathe.run(Machinist::DataMapperAdapter, self.new, *args)
        lathe.object.save!
        lathe.object.reload
        lathe.object(&block)
      end
    end
  end
  
  class DataMapperAdapter
    def self.has_association?(object, attribute)
      false
    end
  end
end

DataMapper::Model.append_extensions(Machinist::DataMapperExtensions)
