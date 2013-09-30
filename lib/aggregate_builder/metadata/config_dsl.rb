module AggregateBuilder
  module Metadata
    class ConfigDSL
      def initialize(config_rules)
        @config_rules = config_rules
      end

      def search_key(key, &block)
        @config_rules.set_search_key(key, &block)
      end

      def delete_key(key, &block)
        raise ArgumentError, "Delete key should be a symbol" unless key.is_a?(Symbol)
        @config_rules.set_delete_key(key, &block)
      end

      def unmapped_fields_error_level(level)
        @config_rules.set_unmapped_fields_error_level(level)
      end
    end
  end
end
