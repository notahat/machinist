require 'machinist'
require 'machinist/blueprints'
require 'sequel'

module Machinist

  class SequelAdapter

    def self.has_association?(object, attribute)
      object.class.associations.include? attribute
    end

    def self.class_for_association(object, attribute)
      association = object.class.association_reflection(attribute)
      association && Module.const_get(association[:class_name].to_sym)
    end

    # This method takes care of converting any associated objects,
    # in the hash returned by Lathe#assigned_attributes, into their
    # object ids.
    #
    # For example, let's say we have blueprints like this:
    #
    #   Post.blueprint { }
    #   Comment.blueprint { post }
    #
    # Lathe#assigned_attributes will return { :post => ... }, but
    # we want to pass { :post_id => 1 } to a controller.
    #
    # This method takes care of cleaning this up.
    def self.assigned_attributes_without_associations(lathe)
      attributes = {}
      lathe.assigned_attributes.each_pair do |attribute, value|
        association = lathe.object.class.association_reflection(attribute)
        if association && association[:type] == :many_to_one
          attributes[association[:key]] = value.id
        else
          attributes[attribute] = value
        end
      end
      attributes
    end
  end

  module SequelExtensions

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      def make(*args, &block)
        lathe = Lathe.run(Machinist::SequelAdapter, self.new, *args)
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

      def plan(*args)
        lathe = Lathe.run(Machinist::SequelAdapter, self.new, *args)
        Machinist::SequelAdapter.assigned_attributes_without_associations(lathe)
      end

    end
  end

end

class Sequel::Model
  include Machinist::Blueprints
  include Machinist::SequelExtensions
end
