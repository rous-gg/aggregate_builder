module AggregateBuilder
  class FieldBuilders::ObjectFieldBuilder
    class << self

      def build(field, field_value, object, config, methods_context)
        hash = cast(field.field_name, field_value)
        existing_object = object.send(field.field_name)
        if existing_object && delete?(hash, field, config)
          object.send("#{field_name}=", nil)
        elsif existing_object
          get_builder(field, methods_context).update(existing_object, hash)
        else
          object.send(
            "#{field.field_name}=",
            get_builder(field, methods_context).build(hash)
          )
        end
      end

      def cast(field_name, value)
        if value.nil?
          raise Errors::TypeCastingError, "#{field_name} can't be nil"
        elsif !value.is_a?(Hash)
          raise Errors::TypeCastingError, "Expected to be a hash, got #{value.inspect} for #{field_name}"
        end
        value
      end

      private

      def delete?(hash, field, config)
        deletable = field.options[:deletable]
        deletable ||= true
        if deletable
          delete_key = field.options[:delete_key] || config.delete_key
          if delete_key.is_a?(Symbol)
            delete_key = ->(hash) { hash[delete_key] == true || hash[delete_key] == 'true' }
          end
          delete_key.call(hash)
        end
      end

      def get_builder(field, methods_context)
        if field.options[:builder].is_a?(Symbol)
          methods_context.send(field.options[:builder])
        elsif field.options[:builder].is_a?(Class)
          field.options[:builder].new
        end
      end

    end
  end
end
