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

        def object(field_name, options = {})
          @rules.add_field(field_name, {
            type_caster: :hash,
            field_builder: :object,
            build_options: options
          })
        end

        def objects(field_name, options = {})
          @rules.add_field(field_name, {
            type_caster: :array_of_hashes,
            field_builder: :array_of_objects,
            build_options: options
          })
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
end