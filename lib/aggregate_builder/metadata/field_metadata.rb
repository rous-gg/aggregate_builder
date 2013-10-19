module AggregateBuilder
  module Metadata
    class FieldMetadata

      DEFAULT_TYPE = :string
      DEFAULT_FIELD_BUILDER = :single_value
      DEFAULT_SEARCH_BLOCK = Proc.new {|entity, attrs| entity.id && entity.id == attrs[:id] }

      attr_reader :field_name
      attr_reader :aliases
      attr_reader :type
      attr_reader :value_processor
      attr_reader :ignore

      def initialize(field_name, options = {})
        raise ArgumentError, "You should provide symbolized name for #{field_name}" unless field_name.is_a?(Symbol)
        @field_name       = field_name
        @type             = extract_type(options)
        @aliases          = extract_aliases(options)
        @field_builder    = options[:field_builder] || DEFAULT_FIELD_BUILDER
        @build_options    = prepare_build_options(options[:build_options])
        @if_block         = options[:if]
        @unless_block     = options[:unless]
      end

      def keys
        [@field_name] + aliases
      end

      def build(field_value, entity, methods_context)
        field_value = type_caster.cast(field_value)
        field_builder.build(@field_name, field_value, entity, @build_options, methods_context)
      end

      private

      def type_caster
        if @type.is_a?(Class)
          @type
        else
          TypeCasters.type_caster_by_name(@type)
        end
      end

      def field_builder
        if @field_builder.is_a?(Class)
          @field_builder
        else
          FieldBuilders.field_builder_by_name(@field_builder)
        end
      end

      def prepare_build_options(build_options)
        build_options ||= {}
        build_options[:search_block] ||= DEFAULT_SEARCH_BLOCK
        build_options
      end

      def extract_type(options)
        if !!options[:type]
          if options[:type].is_a?(Class) || options[:type].is_a?(Symbol)
            options[:type]
          else
            raise ArgumentError, "You should provide class or symbol"
          end
        else
          DEFAULT_TYPE
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
