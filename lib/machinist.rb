require 'machinist/blueprint'
require 'machinist/configuration'
require 'machinist/exceptions'
require 'machinist/lathe'
require 'machinist/machinable'
require 'machinist/shop'
require 'machinist/warehouse'

module Machinist

  # Call this before each test to get Machinist ready.
  def self.reset_before_test
    Shop.instance.restock
  end

end

