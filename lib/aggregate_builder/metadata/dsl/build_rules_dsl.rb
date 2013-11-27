module AggregateBuilder
  module Metadata
    module DSL
      class BuildRulesDSL
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

        def primary_field(field_name, options = {})
          options[:immutable] = true
          @rules.add_field(field_name, options)
        end

        def object(field_name, options = {})
          options[:type] = :object
          @rules.add_field(field_name, options)
        end

        def objects(field_name, options = {})
          options[:type] = :array_of_objects
          @rules.add_field(field_name, options)
        end

        # Callbacks:
        def before_change(method_name = nil, &block)
          @rules.add_callback(:before_change, method_name, &block)
        end

        def before_build(method_name = nil, &block)
          @rules.add_callback(:before_build, method_name, &block)
        end

        def before_update(method_name = nil, &block)
          @rules.add_callback(:before_update, method_name, &block)
        end

        def after_build(method_name = nil, &block)
          @rules.add_callback(:after_build, method_name, &block)
        end

        def after_update(method_name = nil, &block)
          @rules.add_callback(:after_update, method_name, &block)
        end

        def after_change(method_name = nil, &block)
          @rules.add_callback(:after_change, method_name, &block)
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
end
