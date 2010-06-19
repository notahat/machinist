module Machinist
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc <<DESC
Description:
    Copy Machinist files to your application.
DESC

      def generate_blueprints_file
        copy_file "blueprints.rb", "spec/support/blueprints.rb" 
      end

      def install_shop_reset
        text = "  # Reset the Machinist cache before each spec\n  config.before(:each) { Machinist::Shop.reset }\n\n"
        inject_into_file "spec/spec_helper.rb", text, :after => "Rspec.configure do |config|\n"
      end

    end
  end
end
