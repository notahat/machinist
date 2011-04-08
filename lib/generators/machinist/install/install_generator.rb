module Machinist
  module Generators #:nodoc:
    class InstallGenerator < Rails::Generators::Base #:nodoc:
      source_root File.expand_path('../templates', __FILE__)

      class_option :test_framework, :type => :string, :aliases => "-t", :desc => "Test framework to use Machinist with"
      class_option :cucumber, :type => :boolean, :desc => "Set up access to Machinist from Cucumber"

      def blueprints_file
        if rspec?
          copy_file "blueprints.rb", "spec/support/blueprints.rb" 
        else
          copy_file "blueprints.rb", "test/blueprints.rb"
        end
      end

      def test_helper
        unless rspec?
          inject_into_file("test/test_helper.rb", :after => "require 'rails/test_help'\n") do
            "require File.expand_path(File.dirname(__FILE__) + '/blueprints')\n"
          end
        end
      end
      
      def cucumber_support
        if options[:cucumber]
          template "machinist.rb.erb", "features/support/machinist.rb"
        end
      end

    private

      def rspec?
        options[:test_framework].to_sym == :rspec
      end

    end
  end
end
