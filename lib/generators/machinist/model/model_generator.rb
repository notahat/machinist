module Machinist
  module Generators
    class ModelGenerator < Rails::Generators::NamedBase
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_blueprint
        append_file "spec/support/blueprints.rb", "\n#{class_name}.blueprint do\n  # Attributes here\nend\n"
      end

    end
  end
end

