module AggregateBuilder
  module Buildable
    extend ClassMethods

    module ClassMethods
      def build_rules(aggregate_class = nil, &block)
        raise ArgumentError, "You should provide block" unless block_given?
        RulesMetadata::DSL.new
      end

      def build_rules_for(aggregate_class, &block)
        raise ArgumentError, "You should provide class" unless aggregate_class.is_a?(Class)
        build_rules(aggregate_class, &block)
      end
    end

    def build(entity_or_nil, attributes, &block)
      raise ArgumentError, "Attributes should be a hash" unless attributes.is_a?(Hash)

      (entity_or_nil || builder_rules.root_class.new).tap do |entity|
        attributes = prepare_attributes(entity, attributes)
        check_attributes(attributes)
        run_before_build_callbacks(entity, attributes)
        set_attributes(entity, attributes)
        build_nested_associations(entity, attributes)
        run_after_build_callbacks
      end
    end

    def check_attributes(attributes)
      builder_rules.check_attributes(attributes)
    end

    private

    def prepare_attributes(attributes)
      attributes
    end

    def set_attributes(entity, attributes)
      builder_rules.fields_collection.each do |field|
        value = get_value
        field.aliases
        clean_value()
        if field.required?
        end
        if field.allow_nil?
        end
      end
    end

    def builder_rules
      class_variable_get(:@@builder_rules)
    end
  end
end
