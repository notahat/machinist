require 'machinist/blueprint.rb'
require 'machinist/lathe.rb'
require 'machinist/machinable.rb'
require 'machinist/shop.rb'
require 'machinist/warehouse.rb'

module Machinist

  # Call this before each test to get Machinist ready.
  def self.reset_before_test
    Shop.instance.restock
  end

end

