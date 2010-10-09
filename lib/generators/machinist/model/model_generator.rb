module Machinist
  module Generators #:nodoc:
    class ModelGenerator < Rails::Generators::NamedBase #:nodoc:
      argument :attributes, :type => :array, :default => [], :banner => "field:type field:type"

      def create_blueprint
        if attributes.empty?
          fields = "  # Attributes here\n"
        else
          fields = ''
          attributes.each do |a|
            fields << "  #{a.name} { #{a.default.inspect} }\n"
          end
        end

        append_file "spec/support/blueprints.rb", "\n#{class_name}.blueprint do\n#{fields}end\n"
      end

    end
  end
end

