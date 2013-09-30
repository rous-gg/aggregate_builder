module AggregateBuilder
  module Metadata
    class ConfigRules
      UNMAPPED_FIELDS_ERROR_LEVELS = [:silent, :warn, :error]

      attr_accessor :search_key_block
      attr_accessor :search_key
      attr_accessor :delete_key
      attr_accessor :delete_key_block
      attr_accessor :unmapped_fields_error_level

      def initialize
        @search_key = :id
        @delete_key = :delete
        @search_key_block = default_search_block
        @delete_key_block = default_delete_block
      end

      def set_unmapped_fields_error_level(level)
        raise ArgumentError, "Unsupported error level" if !UNMAPPED_FIELDS_ERROR_LEVELS.include?(level)
        @unmapped_fields_error_level = level
      end

      def set_delete_key(key, &block)
        raise ArgumentError, "Delete term should be a symbol" unless key.is_a?(Symbol)
        @delete_key = key
        if block_given?
          @delete_key_block = block
        else
          @delete_key_block = default_delete_block
        end
      end

      def set_search_key(key, &block)
        raise ArgumentError, "Search key should be a symbol" unless key.is_a?(Symbol)
        @search_key = key
        if block_given?
          @search_key_block = block
        else
          @search_key_block = default_search_block
        end
      end

      private

      def default_search_block
        Proc.new do |id|
          id
        end
      end

      def default_delete_block
        Proc.new do |value|
          value
        end
      end
    end
  end
end
