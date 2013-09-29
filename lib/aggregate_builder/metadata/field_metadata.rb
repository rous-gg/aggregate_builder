module AggregateBuilder
  module Metadata
    class FieldMetadata
      DEFAULT_CLEANER_TYPE = :string

      attr_reader :field_name
      attr_reader :aliases
      attr_reader :cleaner_type
      attr_reader :value_processor

      def initialize(field_name, options = {}, value_processor)
        raise ArgumentError, "You should provide symbolized name for #{field_name}" unless field_name.is_a?(Symbol)
        @field_name       = field_name
        @options          = options
        @value_processor  = value_processor
      end

      def keys
        [@field_name] + aliases
      end

      def required?
        !!@options[:required]
      end

      def allow_nil?
        !!@options[:allow_nil]
      end

      def cleaner_type
        @cleaner_type ||= extract_cleaner_type(options)
      end

      def aliases
        @aliases ||= extract_aliases(options)
      end

      private

      def extract_cleaner_type(options)
        if options[:type].present?
          options[:type]
        else
          DEFAULT_CLEANER_TYPE
        end
      end

      def extract_aliases(options)
        if options[:aliases].is_a?(Array) && options[:aliases].all? {|a| a.is_a?(Symbol)}
          options[:aliases]
        else
          raise ArgumentError, "You should provide array of symbols as aliases"
        end
      end
    end
  end
end
