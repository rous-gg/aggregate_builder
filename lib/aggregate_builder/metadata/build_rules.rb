module AggregateBuilder
  module Metadata
    class BuildRules
      CALLBACKS = [:before, :after]

      attr_accessor :root_class
      attr_reader   :fields_collection
      attr_reader   :callbacks
      attr_reader   :config

      def initialize
        @fields_collection  = FieldsCollection.new
        @callbacks          = CallbacksCollection.new
        @config             = Metadata::BuildConfig.new
      end

      def clone
        clonned = self.class.new
        clonned.instance_variable_set(:@fields_collection, @fields_collection.clone)
        clonned.instance_variable_set(:@callbacks,         @callbacks.clone)
        clonned.instance_variable_set(:@config,            @config.clone)
        clonned
      end

      def add_field(field_name, options = {}, &block)
        raise ArgumentError, "You should provide symbol" unless field_name.is_a?(Symbol)
        field = @fields_collection.find(field_name)
        if field
          @fields_collection.delete(field_name)
        end
        options[:build_options] ||= {}
        options[:build_options][:search_block] ||= @config.search_block
        options[:build_options][:delete_block] ||= @config.delete_block
        @fields_collection << Field.new(field_name, options)
      end

      def add_callback(callback_type, method_name = nil, &block)
        if !method_name.nil? && !method_name.is_a?(Symbol)
          raise ArgumentError, "Callback method name should be a symbol" unless method_name.is_a?(Symbol)
        end
        raise ArgumentError, "Unsupported callback type" if !CALLBACKS.include?(callback_type)
        @callbacks.add(callback_type, method_name, &block)
      end

    end
  end
end
