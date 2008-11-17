require 'active_record'

if RAILS_ENV == 'test'
  require 'machinist'
  require 'sham'

  class ActiveRecord::Base
    include Machinist::ActiveRecordExtensions
  end
end
