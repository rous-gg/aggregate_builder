module AggregateBuilder
  class FieldBuilders::ObjectFieldBuilder
    class << self

      def build(field, field_value, object, config, methods_context)
        hash = cast(field.field_name, field_value)
        existing_object = object.send(field.field_name)
        if existing_object && delete?(hash, field, config)
          object.send("#{field_name}=", nil)
        elsif existing_object
          field.options[:builder].new.update(existing_object, hash)
        else
          object.send("#{field.field_name}=", field.options[:builder].new.build(hash))
        end
      end

      def cast(field_name, value)
        unless value.is_a?(Hash)
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

    end
  end
end
