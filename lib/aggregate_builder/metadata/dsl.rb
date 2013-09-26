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
        @rules.add_field(field_name, options, &block)
      end

      def build_children(child_name, options = {}, &block)
        raise ArgumentError, "You should provide block" unless block_given?
        @rules.add_children(child_name, options, &block)
      end

      def before_build(method_name = nil, &block)
        @rules.add_callback(:before, method_name, &block)
      end

      def after_build(method_name = nil, &block)
        @rules.add_callback(:after, method_name, &block)
      end

      def search_key(key, &block)
        @rules.search_key = key
        if block_given?
          @rules.search_key_block = &block
        end
      end

      def delete_term(term, &block)
        @rules.delete_term = term
        if block_given?
          @rules.delete_term_block = &block
        end
      end

      def unmapped_fields_error_level(level)
        @rules.unmapped_fields_error_level = level
      end

      private

      def extract_options(args)
        if args.last.is_a?(Hash)
          args.pop
        end
      end
    end
  end
end
