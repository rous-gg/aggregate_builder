module AggregateBuilder
  module Metadata
    class Field

      DEFAULT_TYPE_CASTER   = :string
      DEFAULT_FIELD_BUILDER = :primitive

      attr_reader :field_name
      attr_reader :aliases
      attr_reader :build_options

      def initialize(field_name, options = {})
        raise ArgumentError, "You should provide symbolized name for #{field_name}" unless field_name.is_a?(Symbol)
        @field_name     = field_name
        @aliases        = extract_aliases(options)
        @type_caster    = options[:type_caster] || DEFAULT_TYPE_CASTER
        @field_builder  = options[:field_builder] || DEFAULT_FIELD_BUILDER
        @build_options  = options[:build_options] || {}
      end

      def keys
        [@field_name] + aliases
      end

      def type_caster
        if @type_caster.is_a?(Class)
          @type_caster
        else
          TypeCasters.type_caster_by_name(@type_caster)
        end
      end

      def field_builder
        if @field_builder.is_a?(Class)
          @field_builder
        else
          FieldBuilders.field_builder_by_name(@field_builder)
        end
      end

      private

      def extract_aliases(options)
        return [] unless options[:aliases]
        if options[:aliases].is_a?(Array) && options[:aliases].all? {|a| a.is_a?(Symbol)}
          options[:aliases]
        else
          raise ArgumentError, "You should provide array of symbols as aliases"
        end
      end

    end
  end
end
