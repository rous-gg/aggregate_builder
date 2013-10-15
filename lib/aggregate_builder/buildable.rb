module AggregateBuilder
  module Buildable
    extend ActiveSupport::Concern

    included do
      class_attribute :builder_rules
    end

    module ClassMethods
      def inherited(base)
        base.builder_rules = self.builder_rules.clone if self.builder_rules
      end

      def config_builder(&block)
        raise ArgumentError, "You should provide block" unless block_given?
        dsl = Metadata::ConfigDSL.new(get_or_build_rules.config)
        dsl.instance_exec &block
      end

      def build_rules(root_class = nil, &block)
        raise ArgumentError, "You should provide block" unless block_given?
        rules = get_or_build_rules
        dsl   = Metadata::DSL.new(rules)
        set_root_class(rules, root_class)
        dsl.instance_exec(&block)
      end

      def build_defaults(&block)
        raise ArgumentError, "You should provide block" unless block_given?
        rules = get_or_build_rules
        dsl   = Metadata::DSL.new(rules)
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
          class_name.sub(/Builder$/, '').constantize
        else
          raise Errors::UndefinedRootClassError, "Unable to set aggregate class from builder name"
        end
      rescue NameError => e
        raise Errors::UndefinedRootClassError, "Unable to set aggregate class from builder name"
      end

      def get_or_build_rules
        self.builder_rules ||= Metadata::BuilderRules.new
      end
    end

    def build(entity_or_nil, attributes, &block)
      raise ArgumentError, "Attributes should be a hash" unless attributes.is_a?(Hash)
      raise Errors::UndefinedRootClassError, "Aggregate root class is not defined" if !builder_rules.root_class

      attributes = attributes.dup
      (entity_or_nil || builder_rules.root_class.new).tap do |entity|
        run_before_build_callbacks(entity, attributes)
        build_entity(entity, attributes)
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

    def run_before_build_children_callbacks(entity, attributes)
      run_callbacks(:before_children, entity, attributes)
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

    def build_entity(entity, attributes)
      EntityBuilder.new(builder_rules, attributes, entity, self).build
    end

  end
end
