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
        @blueprint = blueprint
      end
  
      def make(attributes = {})
        raise "No blueprint for class #{self}" if @blueprint.nil?
        lathe = Lathe.new(self, attributes)
        lathe.instance_eval(&@blueprint)
        unless Machinist.nerfed?
          lathe.object.save!
          lathe.object.reload
        end
        returning(lathe.object) do |object|
          yield object if block_given?
        end
      end
    
      def make_unsaved(attributes = {})
        returning(Machinist.with_save_nerfed { make(attributes) }) do |object|
          yield object if block_given?
        end
      end
    end
  end
  
  class Lathe
    def initialize(klass, attributes = {})
      @object = klass.new
      attributes.each {|key, value| @object.send("#{key}=", value) }
      @assigned_attributes = attributes.keys.map(&:to_sym)
    end

    # Undef a couple of methods that are common ActiveRecord attributes.
    # (Both of these are deprecated in Ruby 1.8 anyway.)
    undef_method :id
    undef_method :type
    
    attr_reader :object

    def method_missing(symbol, *args, &block)
      if @assigned_attributes.include?(symbol)
        @object.send(symbol)
      else
        value = if block
          block.call
        elsif args.first.is_a?(Hash) || args.empty?
          symbol.to_s.camelize.constantize.make(args.first || {})
        else
          args.first
        end
        @object.send("#{symbol}=", value)
        @assigned_attributes << symbol
      end
    end
  end
end

class ActiveRecord::Base
  include Machinist::ActiveRecordExtensions
end

