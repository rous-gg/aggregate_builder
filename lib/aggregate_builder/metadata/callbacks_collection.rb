module AggregateBuilder
  module Metadata
    class CallbacksCollection
      def initialize
        @callbacks = {}
      end

      def clone
        clonned = self.class.new
        clonned_callbacks = {}
        @callbacks.each do |type, callback|
          clonned_callbacks[type] = callback.dup
        end
        clonned.instance_variable_set(:@callbacks, clonned_callbacks)
        clonned
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
