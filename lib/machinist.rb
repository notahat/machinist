require 'active_support'
require 'active_record'
require 'sham'
 
module Machinist
  def self.with_save_nerfed
    begin
      @@nerfed = true
      yield
    ensure
      @@nerfed = false
    end
  end
  
  @@nerfed = false
  def self.nerfed?
    @@nerfed
  end
  
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

      def plan(attributes = {})
        lathe = Lathe.run(self.new, attributes)
        lathe.assigned_attributes
      end
          
      def make_unsaved(attributes = {})
        returning(Machinist.with_save_nerfed { make(attributes) }) do |object|
          yield object if block_given?
        end
      end
    end
  end
  
  module ActiveRecordAssociationExtensions
    def make(attributes = {}, &block)
      lathe = Machinist::Lathe.run(self.build, attributes)
      unless Machinist.nerfed?
        lathe.object.save!
        lathe.object.reload
      end
      lathe.object(&block)
    end

    def plan(attributes = {})
      lathe = Machinist::Lathe.run(self.build, attributes)
      lathe.assigned_attributes
    end
  end
  
  class Lathe
    def self.run(object, attributes = {})
      blueprint = object.class.blueprint
      raise "No blueprint for class #{object.class}" if blueprint.nil?
      returning self.new(object, attributes) do |lathe|
        lathe.instance_eval(&blueprint)
      end
    end
    
    def initialize(object, attributes = {})
      @object = object
      @assigned_attributes = {}
      attributes.each do |key, value|
        @object.send("#{key}=", value)
        @assigned_attributes[key.to_sym] = value
      end
    end

    # Undef a couple of methods that are common ActiveRecord attributes.
    # (Both of these are deprecated in Ruby 1.8 anyway.)
    undef_method :id
    undef_method :type
    
    def object
      yield @object if block_given?
      @object
    end
    
    attr_reader :assigned_attributes
    
    def method_missing(symbol, *args, &block)
      if @assigned_attributes.has_key?(symbol)
        @object.send(symbol)
      elsif @object.class.reflect_on_association(symbol) && !@object.send(symbol).nil?
        @object.send(symbol)
      else
        @object.send("#{symbol}=", generate_attribute(symbol, args, &block))
      end
    end
    
    def generate_attribute(symbol, args)
      value = if block_given?
        yield
      elsif args.first.is_a?(Hash) || args.empty?
        klass = @object.class.reflect_on_association(symbol).class_name.constantize
        klass.make(args.first || {})
      else
        args.first
      end
      @assigned_attributes[symbol] = value
    end
    
  end
end

class ActiveRecord::Base
  include Machinist::ActiveRecordExtensions
end

class ActiveRecord::Associations::AssociationProxy
  include Machinist::ActiveRecordAssociationExtensions
end
