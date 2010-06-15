require 'machinist/machinable'
require 'machinist/collection/blueprint'
require 'machinist/collection/lathe'

module Machinist
  class Collection
    extend Machinist::Machinable

    def initialize
      @attributes = {}
    end

    def method_missing(symbol, *args)
      if symbol.to_s =~ /=$/
        raise ArgumentError("wrong number of arguments(#{args.length} for 1)") unless args.length == 1
        @attributes[symbol.to_s.chop.to_sym] = args[0]
      else
        raise ArgumentError("wrong number of arguments(#{args.length} for 0)") unless args.empty?
        if @attributes.has_key?(symbol) 
          @attributes[symbol]
        else
          raise NoMethodError("#{symbol}")
        end
      end
    end

    def self.blueprint_class
      Machinist::Collection::Blueprint
    end

  end
end


