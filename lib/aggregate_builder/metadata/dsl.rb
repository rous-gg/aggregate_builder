module AggregateBuilder
  module Metadata
    class DSL
      def initialize(rules)
        @rules = rules
      end

      def fields(*args)
        options = extract_options(args)
        args.each do |arg|
          @rules.add_field(arg, options)
        end
      end

      def field(field_name, field_options = {}, &block)
        @rules.add_field(field_name, field_options, &block)
      end

      def build_children(child_name, options = {}, &block)
        @rules.add_children(child_name, options, &block)
      end

      def before_build(method_name = nil, &block)
        @rules.add_callback(:before, method_name, &block)
      end

      def before_build_children(method_name = nil, &block)
        @rules.add_callback(:before_children, method_name, &block)
      end

      def after_build(method_name = nil, &block)
        @rules.add_callback(:after, method_name, &block)
      end

      private

      def extract_options(args)
        if args.last.is_a?(Hash)
          args.pop
        else
          {}
        end
      end
    end
  end
end
