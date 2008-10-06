if RAILS_ENV == 'test'
  require 'machinist'

  class ActiveRecord::Base
    include Machinist
  end
end
