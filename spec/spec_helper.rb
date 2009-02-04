$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'test/unit'
require 'spec'
require 'active_record'
require 'sham'

config = YAML::load(IO.read(File.dirname(__FILE__) + "/db/database.yml"))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/log/test.log")
ActiveRecord::Base.establish_connection(config['test'])
load(File.dirname(__FILE__) + "/db/schema.rb")

Spec::Runner.configure do |config|
  config.before(:each) { Sham.reset }
end
