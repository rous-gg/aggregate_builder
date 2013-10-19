module AggregateBuilder
  module Buildable
    extend ActiveSupport::Concern

    included do
      class_attribute :rules, :config
    end

    module ClassMethods
      def inherited(subclass)
        if self.rules
          subclass.rules = self.rules.clone
        end
      end

      def build_config(&block)
        raise ArgumentError, "You should provide block" unless block_given?
        self.config ||= Metadata::BuildConfig.new
        Metadata::BuildConfigDSL.new(self.config).instance_exec(&block)
      end

      def build_rules(root_class = nil, &block)
        raise ArgumentError, "You should provide block" unless block_given?
        self.rules ||= Metadata::BuildRules.new
        self.rules.root_class = root_class ? root_class : root_class_from_builder_name
        Metadata::BuildRulesDSL.new(self.rules).instance_exec(&block)
      end

      def build_rules_for(root_class, &block)
        raise ArgumentError, "You should provide class" unless root_class.is_a?(Class)
        build_rules(root_class, &block)
      end

      private

      def root_class_from_builder_name
        class_name = self.to_s.split("::").last
        if class_name =~ /Builder$/
          class_name.sub(/Builder$/, '').constantize
        else
          nil
        end
      rescue NameError => e
        nil
      end
    end

    def build(entity_or_nil, attributes, &block)
      raise ArgumentError, "Attributes should be a hash" unless attributes.is_a?(Hash)
      raise Errors::UndefinedRootClassError, "Aggregate root class is not defined" if !rules.root_class

      attributes = attributes.dup
      (entity_or_nil || self.rules.root_class.new).tap do |entity|
        run_before_build_callbacks(entity, attributes)
        build_entity(entity, attributes)
        run_after_build_callbacks(entity, attributes)
      end
    end

    private

    def run_before_build_callbacks(entity, attributes)
      run_callbacks(:before, entity, attributes)
    end

    def run_after_build_callbacks(entity, attributes)
      run_callbacks(:after, entity, attributes)
    end

    def run_callbacks(type, entity, attributes)
      rules.callbacks.callbacks_by_type(type).each do |callback|
        if callback.method_name
          send(callback.method_name, entity, attributes)
        else
          instance_exec entity, attributes, &callback.callback_block
        end
      end
    end

    def build_entity(entity, attributes)
      EntityBuilder.new(rules, attributes, entity, self).build
    end

  end
end
