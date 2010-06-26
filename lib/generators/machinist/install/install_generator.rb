module Machinist
  module Generators #:nodoc:
    class InstallGenerator < Rails::Generators::Base #:nodoc:
      source_root File.expand_path('../templates', __FILE__)

      class_option :test_framework, :type => :string, :aliases => "-t", :desc => "Test framework to use Machinist with"
      class_option :cucumber, :type => :boolean, :desc => "Set up access to Machinist from Cucumber"

      def generate_blueprints_file
        if rspec?
          copy_file "blueprints.rb", "spec/support/blueprints.rb" 
        else
          copy_file "blueprints.rb", "test/blueprints.rb"
        end
      end

      def install_shop_reset
        if rspec?
          inject_into_file(
            "spec/spec_helper.rb",
            "  # Reset the Machinist cache before each spec.\n  config.before(:each) { Machinist.reset_before_test }\n\n",
            :after => "Rspec.configure do |config|\n"
          )
        else
          inject_into_file(
            "test/test_helper.rb",
            "require File.expand_path(File.dirname(__FILE__) + '/blueprints')\n",
            :after => "require 'rails/test_help'\n"
          )
          inject_into_file(
            "test/test_helper.rb",
            "  # Reset the Machinist cache before each test.\n  setup { Machinist.reset_before_test }\n\n",
            :after => "class ActiveSupport::TestCase\n"
          )
        end
      end
      
      def install_cucumber_support
        if cucumber?
          template "machinist.rb.erb", "features/support/machinist.rb"
        end
      end

    private

      def rspec?
        options[:test_framework].to_sym == :rspec
      end

      def cucumber?
        options[:cucumber]
      end

    end
  end
end
