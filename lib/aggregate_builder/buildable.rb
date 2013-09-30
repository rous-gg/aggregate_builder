module AggregateBuilder
  module Buildable
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def build_rules(root_class = nil, &block)
        raise ArgumentError, "You should provide block" unless block_given?
        rules = builder_rules
        dsl   = Metadata::DSL.new(rules)
        set_root_class(rules, root_class)
        dsl.instance_exec(&block)
      end

      def build_rules_for(root_class, &block)
        raise ArgumentError, "You should provide class" unless root_class.is_a?(Class)
        build_rules(root_class, &block)
      end

      private

      def set_root_class(rules, root_class)
        rules.root_class = root_class.nil? ? extract_default_root_class : root_class
      end

      def extract_default_root_class
        class_name = self.to_s.split("::").last
        if class_name =~ /Builder$/
          Object.const_get(class_name.sub(/Builder$/, ''))
        else
          raise Errors::UndefinedRootClassError, "Unable to set aggregate class from builder name"
        end
      end

      def builder_rules
        rules = if class_variables.include?(:@@builder_rules)
          class_variable_get(:@@builder_rules)
        end
        if rules.nil?
          rules = Metadata::BuilderRules.new
          class_variable_set(:@@builder_rules, rules)
        end
        rules
      end

    end

    def build(entity_or_nil, attributes, &block)
      raise ArgumentError, "Attributes should be a hash" unless attributes.is_a?(Hash)

      attributes = attributes.dup
      (entity_or_nil || builder_rules.root_class.new).tap do |entity|
        prepare_attributes(entity, attributes)
        run_before_build_callbacks(entity, attributes)
        processed_attributes = process_attributes(attributes, entity)
        set_attributes(entity, processed_attributes)
        build_nested_associations(entity, attributes)
        run_after_build_callbacks(entity, attributes)
      end
    end

    def check_attributes(attributes)
      builder_rules.check_attributes(attributes)
    end

    private

    def run_before_build_callbacks(entity, attributes)
      run_callbacks(:before, entity, attributes)
    end

    def run_after_build_callbacks(entity, attributes)
      run_callbacks(:after, entity, attributes)
    end

    def run_callbacks(type, entity, attributes)
      builder_rules.callbacks.callbacks_by_type(type).each do |callback|
        if callback.method_name
          send(callback.method_name, entity, attributes)
        else
          instance_exec entity, attributes, &callback.callback_block
        end
      end
    end

    def prepare_attributes(entity, attributes)
      processor = ChildrenProcessor.new(builder_rules)
      processor.process(entity, attributes)
    end

    def process_attributes(attributes, entity)
      processor = AttributesProcessor.new(builder_rules, self)
      processor.process(attributes, entity)
    end

    def set_attributes(entity, processed_attributes)
      builder_rules.fields_collection.each do |field|
        entity.send("#{field.field_name}=", processed_attributes[field.field_name])
      end
    end

    def build_nested_associations(entity, attributes)
      # TODO: add nested processing here
    end

    def builder_rules
      @builder_rules ||= self.class.class_variable_get(:@@builder_rules)
    end
  end
end
