require 'active_record'
require 'machinist'
require 'machinist/active_record/blueprint'
require 'machinist/active_record/lathe'

class ActiveRecord::Base #:nodoc:
  extend Machinist::Machinable

  def self.blueprint_class
    Machinist::ActiveRecord::Blueprint
  end
end
