$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
$LOAD_PATH.unshift File.dirname(__FILE__)

require 'rubygems'
require 'test/unit'
require 'rspec'
require 'machinist'

Machinist.configure do |config|
  config.cache_objects = true
end
