module AggregateBuilder
  module Metadata
    class ChildrenDSL
      def initialize(child_metadata)
        @child_metadata = child_metadata
      end

      def builder(builder_klass_or_method_name)
        if !(builder_klass_or_method_name.is_a?(Class) || builder_klass_or_method_name.is_a?(Symbol))
          raise ArgumentError, "You should provide builder class or method name"
        end
        @child_metadata.builder = builder_klass_or_method_name
      end

      def reject_if(&block)
        raise ArgumentError, "You sould provide block" unless block_given?
        @child_metadata.reject_if_block = block
      end

      def deletable(flag)
        @child_metadata.deletable = flag
      end
    end
  end
end
