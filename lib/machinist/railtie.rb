module Machinist
  class Railtie < ::Rails::Railtie
    config.generators.fixture_replacement :machinist
  end
end
