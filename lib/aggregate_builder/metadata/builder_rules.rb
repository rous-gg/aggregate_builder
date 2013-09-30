module AggregateBuilder
  module Metadata
    class BuilderRules
      attr_accessor :root_class
      attr_accessor :search_key_block
      attr_accessor :search_key
      attr_accessor :delete_key
      attr_accessor :delete_key_block
      attr_reader   :fields_collection
      attr_accessor :unmapped_fields_error_level

      CALLBACKS = [:before, :after]
      UNMAPPED_FIELDS_ERROR_LEVELS = [:silent, :warn, :error]

      def initialize
        @fields_collection           = FieldsCollection.new
        @children_rules              = ChildrenRules.new
        @callbacks                   = CallbacksCollection.new
        @unmapped_fields_error_level = :silent
      end

      def add_field(field_name, options = {}, &block)
        raise ArgumentError, "You should provide symbol" unless field_name.is_a?(Symbol)
        field = @fields_collection.find(field_name)
        @fields_collection.delete(field) if field
        @fields_collection << FieldMetadata.new(field_name, options, &block)
      end

      def add_children(association_name, options = {}, &block)
        raise ArgumentError, "You should provide block" unless block_given?
        raise ArgumentError, "You should provide symbol" unless association_name.is_a?(Symbol)
        @children_rules << ChildrenMetadata.new(association_name, options, &block)
      end

      def add_callback(callback_type, method_name = nil, &block)
        if !method_name.nil? && !method_name.is_a?(Symbol)
          raise ArgumentError, "Callback method name should be a symbol" unless method_name.is_a?(Symbol)
        end
        raise ArgumentError, "Unsupported callback type" if !CALLBACKS.include?(callback_type)
        @callbacks.add(callback_type, method_name, &block)
      end

      def unmapped_fields_error_level(level)
        raise ArgumentError, "Unsupported error level" if !UNMAPPED_FIELDS_ERROR_LEVELS.include?(level)
        @unmapped_fields_error_level = level
      end

      def delete_key(key, &block)
        raise ArgumentError, "Delete term should be a symbol" unless key.is_a?(Symbol)
        @delete_key = key
        if block_given?
          @delete_key_block = block
        end
      end

      def search_key(key, &block)
        raise ArgumentError, "Search key should be a symbol" unless key.is_a?(Symbol)
        @search_key = key
        if block_given?
          @search_key_block = block
        end
      end

      def unmapped_fields_error_level=(level)
        raise ArgumentError, "Unsupported error level" unless [:silent, :warn, :error].include?(level)
        @unmapped_fields_error_level = level
      end

      def check_attributes(attributes)
        if warn_level? || error_level?
          unmapped_keys = extract_unmapped_keys(attributes)
          extract_incorrect_type
          if !unmapped_keys.empty?
            if warn_level?
              p "WARNING: Builder does not accept the following attributes #{unmapped_keys.join(', ')}"
            else
            end
          end
        end
      end

      private

      def extract_unmapped_keys(attributes)
        attributes.keys.map(&:to_sym) - field_keys_with_aliases
      end

      def field_keys_with_aliases
        @fields_collection.map(&:field_name) + @fields_collection.map(&:aliases).flatten
      end

      def warn_level?
        @unmapped_fields_error_level == :warn
      end

      def error_level?
        @unmapped_fields_error_level == :error
      end
    end
  end
end
