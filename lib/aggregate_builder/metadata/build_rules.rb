module AggregateBuilder
  module Metadata
    class BuildRules
      attr_accessor :root_class
      attr_reader   :fields_collection
      attr_reader   :callbacks

      def initialize
        @fields_collection  = FieldsCollection.new
        @callbacks          = CallbacksCollection.new
      end

      def configure(&rules_block)
        Metadata::DSL::BuildRulesDSL.new(self).instance_exec(&rules_block)
      end

      def clone
        clonned = self.class.new
        clonned.instance_variable_set(:@fields_collection, @fields_collection.clone)
        clonned.instance_variable_set(:@callbacks,         @callbacks.clone)
        clonned
      end

      def add_field(field_name, options = {}, &block)
        raise ArgumentError, "You should provide symbol" unless field_name.is_a?(Symbol)
        field = @fields_collection.find(field_name)
        if field
          @fields_collection.delete(field_name)
        end
        @fields_collection << Field.new(field_name, options)
      end

      def add_callback(callback_name, method_name = nil, &block)
        if !method_name.nil? && !method_name.is_a?(Symbol)
          raise ArgumentError, "Callback method name should be a symbol" unless method_name.is_a?(Symbol)
        end
        @callbacks.add(callback_name, method_name, &block)
      end

    end
  end
end
