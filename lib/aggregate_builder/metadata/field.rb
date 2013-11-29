module AggregateBuilder
  module Metadata
    class Field

      DEFAULT_FIELD_BUILDER = :string

      attr_reader :field_name
      attr_reader :aliases
      attr_reader :options

      def initialize(field_name, options = {})
        raise ArgumentError, "You should provide symbolized name for #{field_name}" unless field_name.is_a?(Symbol)
        @field_name     = field_name
        @aliases        = extract_aliases(options)
        @field_builder  = options[:type] || options[:field_builder] || DEFAULT_FIELD_BUILDER
        @options        = options
      end

      def keys
        [@field_name] + aliases
      end

      def field_builder(context)
        if @field_builder.is_a?(Class)
          @field_builder
        else
          if field_builder = FieldBuilders.field_builder_by_name(@field_builder)
            field_builder
          else
            if context.respond_to?(@field_builder)
              context.send(@field_builder)
            else
              raise ArgumentError, "Field builder with name :#{@field_builder} doesn't exist"
            end
          end
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
