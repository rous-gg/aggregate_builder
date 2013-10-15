module AggregateBuilder
  module Metadata
    class BuilderRules
      attr_accessor :root_class
      attr_reader   :fields_collection
      attr_reader   :callbacks
      attr_reader   :children_rules
      attr_reader   :search_block

      CALLBACKS = [:before, :after, :before_children]
      DEFAULT_SEARCH_BLOCK = Proc.new {|entity, attrs| entity.id && entity.id == attrs[:id] }

      def initialize
        @config_rules         = ConfigRules.new
        @fields_collection    = FieldsCollection.new
        @callbacks            = CallbacksCollection.new
        @search_block         = DEFAULT_SEARCH_BLOCK
      end

      def clone
        clonned = self.class.new
        clonned.instance_variable_set(:@config_rules,      @config_rules.dup)
        clonned.instance_variable_set(:@fields_collection, @fields_collection.clone)
        clonned.instance_variable_set(:@callbacks,         @callbacks.clone)
        clonned
      end

      def config
        @config_rules
      end

      def add_field(field_name, options = {}, &block)
        raise ArgumentError, "You should provide symbol" unless field_name.is_a?(Symbol)
        field = @fields_collection.find(field_name)
        raise ArgumentError, "The field with name #{field_name} defined multiple times" if field
        @fields_collection << FieldMetadata.new(field_name, options, block)
      end

      def add_nested_field(field_name, options = {}, &block)
        raise ArgumentError, "You should provide symbol" unless field_name.is_a?(Symbol)
        field = @fields_collection.find(field_name)
        raise ArgumentError, "The field with name #{field_name} defined multiple times" if field
        @fields_collection << NestedFieldMetadata.new(field_name, options, block)
      end

      def add_callback(callback_type, method_name = nil, &block)
        if !method_name.nil? && !method_name.is_a?(Symbol)
          raise ArgumentError, "Callback method name should be a symbol" unless method_name.is_a?(Symbol)
        end
        raise ArgumentError, "Unsupported callback type" if !CALLBACKS.include?(callback_type)
        @callbacks.add(callback_type, method_name, &block)
      end

      def set_search_block(&search_block)
        @search_block = search_block
      end

      def silent_level?
        config.unmapped_fields_error_level == :silent
      end

      def warn_level?
        config.unmapped_fields_error_level == :warn
      end

      def error_level?
        config.unmapped_fields_error_level == :error
      end
    end
  end
end
