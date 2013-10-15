module AggregateBuilder
  module Metadata
    class FieldMetadata
      attr_reader :field_name
      attr_reader :aliases
      attr_reader :type
      attr_reader :value_processor
      attr_reader :ignore

      def initialize(field_name, options = {}, value_processor)
        raise ArgumentError, "You should provide symbolized name for #{field_name}" unless field_name.is_a?(Symbol)
        @field_name       = field_name
        @options          = options
        @value_processor  = value_processor
        @type             = extract_type(options)
        @aliases          = extract_aliases(options)
        @ignore           = options[:ignore] || false
      end

      def keys
        [@field_name] + aliases
      end

      def has_processing?
        !!@value_processor
      end

      def ignore?
        @ignore
      end

      def build(entity, field_value, methods_context, attrs, builder_rules)
        field_builder.build(entity, self, field_value, methods_context, attrs, builder_rules)
      end

      private

      def field_builder
        if self.type.is_a?(Class)
          self.type
        else
          FieldBuilders.find_field_builder_by_name(self.type)
        end
      end


      def default_caster_type
        :string
      end

      def extract_type(options)
        if !!options[:type]
          if options[:type].is_a?(Class) || options[:type].is_a?(Symbol)
            options[:type]
          else
            raise ArgumentError, "You should provide class or symbol"
          end
        else
         default_caster_type
        end
      end

      def extract_aliases(options)
        if !!options[:aliases]
         if options[:aliases].is_a?(Array) && options[:aliases].all? {|a| a.is_a?(Symbol)}
            options[:aliases]
          else
            raise ArgumentError, "You should provide array of symbols as aliases"
          end
        else
          []
        end
      end
    end
  end
end
