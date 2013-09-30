module AggregateBuilder
  module Metadata
    class BuilderRules
      attr_accessor :root_class
      attr_reader   :fields_collection
      attr_reader   :callbacks
      attr_reader   :children_rules
      attr_reader   :config_rules

      CALLBACKS = [:before, :after]

      def initialize
        @config_rules                = ConfigRules.new
        @fields_collection           = FieldsCollection.new
        @children_rules              = ChildrenRules.new
        @callbacks                   = CallbacksCollection.new
        @unmapped_fields_error_level = :silent
      end

      def add_field(field_name, options = {}, &block)
        raise ArgumentError, "You should provide symbol" unless field_name.is_a?(Symbol)
        field = @fields_collection.find(field_name)
        @fields_collection.delete(field) if field
        @fields_collection << FieldMetadata.new(field_name, options, block)
      end

      def add_children(association_name, options = {}, &block)
        raise ArgumentError, "You should provide block" unless block_given?
        raise ArgumentError, "You should provide symbol" unless association_name.is_a?(Symbol)
        child_metadata = ChildMetadata.new(association_name, options)
        child_dsl = ChildrenDSL.new(child_metadata)
        child_dsl.instance_exec &block
        @children_rules << child_metadata
      end

      def add_callback(callback_type, method_name = nil, &block)
        if !method_name.nil? && !method_name.is_a?(Symbol)
          raise ArgumentError, "Callback method name should be a symbol" unless method_name.is_a?(Symbol)
        end
        raise ArgumentError, "Unsupported callback type" if !CALLBACKS.include?(callback_type)
        @callbacks.add(callback_type, method_name, &block)
      end

      def silent_level?
        @config_rules.unmapped_fields_error_level == :silent
      end

      def warn_level?
        @config_rules.unmapped_fields_error_level == :warn
      end

      def error_level?
        @config_rules.unmapped_fields_error_level == :error
      end
    end
  end
end