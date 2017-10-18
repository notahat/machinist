require 'active_record'
require 'machinist'
require 'machinist/active_record/blueprint'
require 'machinist/active_record/lathe'

module ActiveRecord #:nodoc:
  class Base #:nodoc:
    extend Machinist::Machinable

    after_create :log_record

    def self.blueprint_class
      Machinist::ActiveRecord::Blueprint
    end

    private

    def log_record
      return unless spec_path.present?
      machinist_logger ||= Logger.new('log/machinist.log')
      machinist_logger.debug "+ Create #{self.class.name}"
      machinist_logger.debug "#{spec_path}\n"
    end

    def spec_path
      paths = caller.select { |file| file.include?('./spec/') }.uniq.reverse
      paths.each_with_index.map { |bp, index| "#{index + 1}. #{bp.gsub!('./spec/', '')}" }.join("\n")
    end
  end
end
