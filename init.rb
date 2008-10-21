if RAILS_ENV == 'test'
  require 'machinist'
  require 'sham'

  class ActiveRecord::Base
    include Machinist
  end
end
