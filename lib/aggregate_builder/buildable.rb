module AggregateBuilder
  module Buildable
    extend ActiveSupport::Concern

    included do
      class_attribute :builder_rules, :builder_config
    end

    module ClassMethods
      def inherited(subclass)
        if self.builder_rules
          subclass.builder_rules = self.builder_rules.clone
        end
        if self.builder_config
          subclass.builder_config = self.builder_config.clone
        end
      end

      def build_config(&block)
        raise ArgumentError, "You should provide block" unless block_given?
        self.builder_config ||= Metadata::BuildConfig.new(&block)
        self.builder_config.configure(&block)
      end

      def build_rules(root_class = nil, &block)
        raise ArgumentError, "You should provide block" unless block_given?
        self.builder_config ||= Metadata::BuildConfig.new
        self.builder_rules ||= Metadata::BuildRules.new
        self.builder_rules.configure(&block)
        self.builder_rules.root_class = root_class ? root_class : root_class_from_builder_name
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
      raise Errors::UndefinedRootClassError, "Aggregate root class is not defined" if !builder_rules.root_class

      object = self.builder_rules.root_class.new
      run_callbacks([:before_change, :before_build], object, attributes)
      ObjectBuilder.new(self.builder_rules, self.builder_config, self).build(object, attributes)
      run_callbacks([:after_change, :after_build], object, attributes)
      object
    end

    def update(object, attributes)
      raise ArgumentError, "Attributes should be a hash" unless attributes.is_a?(Hash)
      run_callbacks([:before_change, :before_update], object, attributes)
      ObjectBuilder.new(self.builder_rules, self.builder_config, self).update(object, attributes)
      run_callbacks([:after_change, :after_update], object, attributes)
      object
    end

    private

    def run_callbacks(callback_names, object, attributes, &block)
      callback_names.each do |callback_name|
        run_callback(callback_name, object, attributes)
      end
    end

    def run_callback(callback_name, object, attributes)
      builder_rules.callbacks.callbacks_by_name(callback_name).each do |callback|
        if callback.method_name
          send(callback.method_name, object, attributes)
        else
          instance_exec(object, attributes, &callback.callback_block)
        end
      end
    end

  end
end
