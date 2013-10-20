module AggregateBuilder
  module Buildable
    extend ActiveSupport::Concern

    included do
      class_attribute :rules
    end

    module ClassMethods
      def inherited(subclass)
        if self.rules
          subclass.rules = self.rules.clone
        end
      end

      def build_config(&block)
        raise ArgumentError, "You should provide block" unless block_given?
        self.rules ||= Metadata::BuildRules.new
        Metadata::BuildConfigDSL.new(self.rules.config).instance_exec(&block)
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

    def build(attributes)
      raise ArgumentError, "Attributes should be a hash" unless attributes.is_a?(Hash)
      raise Errors::UndefinedRootClassError, "Aggregate root class is not defined" if !rules.root_class

      object = self.rules.root_class.new
      run_callbacks(object, attributes) do
        ObjectBuilder.new(rules, self).build(object, attributes)
      end
    end

    def update(object, attributes)
      raise ArgumentError, "Attributes should be a hash" unless attributes.is_a?(Hash)
      run_callbacks(object, attributes) do
        ObjectBuilder.new(rules, self).update(object, attributes)
      end
    end

    def patch(object, attributes)
      raise ArgumentError, "Attributes should be a hash" unless attributes.is_a?(Hash)
      run_callbacks(object, attributes) do
        ObjectBuilder.new(rules, self).patch(object, attributes)
      end
    end

    private

    def run_callbacks(object, attributes, &block)
      run_callback(:before, object, attributes)
      object = block.call
      run_callback(:after, object, attributes)
      object
    end

    def run_callback(type, object, attributes)
      rules.callbacks.callbacks_by_type(type).each do |callback|
        if callback.method_name
          send(callback.method_name, object, attributes)
        else
          instance_exec(object, attributes, &callback.callback_block)
        end
      end
    end

  end
end
