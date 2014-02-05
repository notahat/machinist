module Machinist
  module Generators #:nodoc:
    class ModelGenerator < Rails::Generators::NamedBase #:nodoc:
      class_option :test_framework, :type => :string, :aliases => "-t", :desc => "Test framework to use Machinist with"
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_blueprint
        append_file blueprints_path, "\n#{class_name}.blueprint do\n  # Attributes here\nend\n"
      end

      protected

      def blueprints_path
        if options[:test_framework].to_sym == :rspec
          "spec/support/blueprints.rb" 
        else
          "test/blueprints.rb"
        end
      end
    end
  end
end

