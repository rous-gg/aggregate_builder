module AggregateBuilder
  module Metadata
    class ChildrenRules
      def initialize
        @children_collection = []
      end

      def <<(child_metadata)
        delete(child_metadata.child_name)
        @children_collection << child_metadata
      end

      def each(&block)
        @children_collection.each &block
      end

      def delete(child_name)
        child = find(child_name)
        @children_collection.delete(child) if child
      end

      def find(child_name)
        @children_collection.detect do |child|
          child.child_name == child_name
        end
      end
    end
  end
end
