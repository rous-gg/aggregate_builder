module Aggregate
  module Metadata
    class ChildMetadata
      attr_accessor :builder, :deletable
      attr_reader   :child_name

      def initialize(child_name, options = {})
        @child_name = child_name
      end

      def deletable?
        deletable
      end

      def aliases
        @aliases ||= extract_aliases(options)
      end

      private

      def extract_aliases
        if options[:aliases].is_a?(Array) && options[:aliases].all? {|a| a.is_a?(Symbol)}
          options[:aliases]
        else
          raise ArgumentError, "You should provide array of symbols as aliases"
        end
      end

    end
  end
end
