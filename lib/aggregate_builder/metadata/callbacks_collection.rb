module AggregateBuilder
  module Metadata
    class CallbacksCollection
      def initialize
        @callbacks = {}
      end

      def add(callback_type, method_name, &block)
        @callbacks[callback_type] ||= []
        @callbacks[callback_type] << CallbackMetadata.new(method_name, &block)
      end

      def callbacks_by_type(callback_type)
        if !@callbacks[callback_type].nil?
          @callbacks[callback_type]
        else
          []
        end
      end
    end
  end
end