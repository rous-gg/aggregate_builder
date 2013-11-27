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

      def add(callback_name, method_name, &block)
        @callbacks[callback_name] ||= []
        @callbacks[callback_name] << Callback.new(method_name, &block)
      end

      def callbacks_by_name(callback_name)
        if !@callbacks[callback_name].nil?
          @callbacks[callback_name]
        else
          []
        end
      end
    end
  end
end
