module AggregateBuilder
  module Metadata
    class ChildMetadata
      attr_accessor :builder, :deletable, :reject_if_block
      attr_reader   :child_name
      attr_reader   :aliases

      def initialize(child_name, options = {})
        @child_name = child_name
        @aliases    = extract_aliases(options)
      end

      def deletable?
        deletable
      end

      def keys
        [@child_name] + aliases
      end

      # TODO: optimize this
      def key_from(attributes)
        attrs_keys = attributes.keys.map(&:to_sym)
        keys.detect do |key|
          attrs_keys.include?(key)
        end
      end

      private

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
