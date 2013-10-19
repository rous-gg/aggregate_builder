module AggregateBuilder
  module Metadata
    class DSL
      def initialize(rules)
        @rules = rules
      end

      # Fields:
      def field(field_name, options = {})
        @rules.add_field(field_name, options)
      end

      def fields(*args)
        options = extract_options(args)
        args.each do |arg|
          @rules.add_field(arg, options)
        end
      end

      # Configs:
      def search_block(&block)
        @rules.set_search_block(&block)
      end

      # Callbacks:
      def before_build(method_name = nil, &block)
        @rules.add_callback(:before, method_name, &block)
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
