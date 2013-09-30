module AggregateBuilder
  module Metadata
    class CallbackMetadata
      attr_reader :method_name, :callback_block

      def initialize(method_name, &block)
        if method_name.nil? && !block_given?
          raise ArgumentError, "Callback Method name or block is required"
        end
        @method_name    = method_name
        @callback_block = block
      end
    end
  end
end
