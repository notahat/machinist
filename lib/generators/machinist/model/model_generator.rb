module Machinist
  module Generators #:nodoc:
    class ModelGenerator < Rails::Generators::NamedBase #:nodoc:
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_blueprint
        append_file "spec/support/blueprints.rb", "\n#{class_name}.blueprint do\n  # Attributes here\nend\n"
      end

    end
  end
end

