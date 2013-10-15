module AggregateBuilder
  module Metadata
    class NestedFieldMetadata < FieldMetadata
      attr_accessor :builder, :deletable, :reject_if_block, :search_block

      def initialize(field_name, options = {}, value_processor)
        super
        @builder = options[:builder].new || (raise ArgumentError.new("Builder should be specified for nested field"))
        @deletable = options[:deletable] || false
        @reject_if_block = options[:reject_if]
        @search_block    = options[:search_block]
      end

      def deletable?
        self.deletable
      end

      private

      def default_caster_type
        :array_of_hashes
      end

    end
  end
end
