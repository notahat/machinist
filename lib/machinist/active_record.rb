require 'active_record'
require 'machinist'
require 'machinist/active_record/adapter'
require 'machinist/active_record/blueprint'

class ActiveRecord::Base #:nodoc:
  extend Machinist::Machinable

  def self.machinist_adapter
    @machinist_adapter ||= Machinist::ActiveRecord::Adapter.new
  end
end
