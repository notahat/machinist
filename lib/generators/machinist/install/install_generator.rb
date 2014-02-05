module Machinist
  module Generators #:nodoc:
    class InstallGenerator < Rails::Generators::Base #:nodoc:
      source_root File.expand_path('../templates', __FILE__)
      class_option :test_framework, :type => :string, :default => 'test_unit', :aliases => "-t", :desc => "Test framework to use Machinist with"
      class_option :cucumber, :type => :boolean, :default => false, :desc => "Set up access to Machinist from Cucumber"

      def blueprints_file
        if rspec?
          copy_file "blueprints.rb", "spec/support/blueprints.rb" 
        elsif test_unit?
          copy_file "blueprints.rb", "test/blueprints.rb"
        else
          say_status(:error, "No test framework found. Please specify either 'rspec' or 'test_unit' with the -t option.", :red)
        end
      end
      
      def test_helper
        if test_unit? 
          if File.exist?("test/test_helper.rb")
            inject_into_file("test/test_helper.rb", :after => "require 'rails/test_help'\n") do
              "require File.expand_path(File.dirname(__FILE__) + '/blueprints')\n"
            end
          else
            say_status(:warning, "Unable to modify the test_helper file. It does not exist.", :red)
          end
        end
      end

      def cucumber_support
        if cucumber?
          template "machinist.rb.erb", "features/support/machinist.rb"
        end
      end

    private

      def rspec?
        options[:test_framework] and options[:test_framework].to_sym == :rspec 
      end

      def test_unit?        
        options[:test_framework] and options[:test_framework].to_sym == :test_unit
      end

      def cucumber?
        options[:cucumber]
      end
    end
  end
end
