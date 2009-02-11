module Machinist
  
  module ActiveRecordExtensions
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def blueprint(&blueprint)
        @blueprint = blueprint if block_given?
        @blueprint
      end
  
      def make(attributes = {}, &block)
        lathe = Lathe.run(self.new, attributes)
        unless Machinist.nerfed?
          lathe.object.save!
          lathe.object.reload
        end
        lathe.object(&block)
      end

      def make_unsaved(attributes = {})
        returning(Machinist.with_save_nerfed { make(attributes) }) do |object|
          yield object if block_given?
        end
      end
          
      def plan(attributes = {})
        lathe = Lathe.run(self.new, attributes)
        lathe.assigned_attributes
      end
    end
  end
  
  module ActiveRecordAssociationExtensions
    def make(attributes = {}, &block)
      lathe = Lathe.run(self.build, attributes)
      unless Machinist.nerfed?
        lathe.object.save!
        lathe.object.reload
      end
      lathe.object(&block)
    end

    def plan(attributes = {})
      lathe = Lathe.run(self.build, attributes)
      lathe.assigned_attributes
    end
  end
  
end


class ActiveRecord::Base
  include Machinist::ActiveRecordExtensions
end

class ActiveRecord::Associations::BelongsToAssociation
  include Machinist::ActiveRecordAssociationExtensions
end
