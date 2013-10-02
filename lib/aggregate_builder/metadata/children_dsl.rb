module AggregateBuilder
  module Metadata
    class ChildrenDSL
      def initialize(children_rules)
        @children_rules = children_rules
      end

      def builder(builder_klass_or_method_name)
        if !(builder_klass_or_method_name.is_a?(Class) || builder_klass_or_method_name.is_a?(Symbol))
          raise ArgumentError, "You should provide builder class or method name"
        end
        @children_rules.builder = builder_klass_or_method_name
      end

      def deletable(flag)
        @children_rules.deletable = flag
      end
    end
  end
end
