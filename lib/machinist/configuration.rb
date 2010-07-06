module Machinist

  # Configure Machinist.
  #
  # To change Machinist configuration, do something like this in your
  # config/environments/test.rb or somewhere similar:
  #
  #     Machinist.configure do |config|
  #       config.cache_objects = false
  #     end
  class Configuration
    # Set this to false to disable object caching. Defaults to true.
    attr_accessor :cache_objects

    def cache_objects? #:nodoc:
      @cache_objects
    end

    def initialize #:nodoc:
      self.cache_objects = true
    end
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

end
