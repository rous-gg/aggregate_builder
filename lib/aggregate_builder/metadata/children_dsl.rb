module AggregateBuilder
  module Metadata
    class ChildrenDSL
      def initialize(children_rules)
        @children_rules = children_rules
      end

      def builder(builder_klass)
        raise ArgumentError, "You should provide builder class" unless builder_klass.is_a?(Class)
        @children_rules.builder = builder_klass
      end

      def deletable(flag)
        @children_rules.deletable = flag
      end
    end
  end
end
