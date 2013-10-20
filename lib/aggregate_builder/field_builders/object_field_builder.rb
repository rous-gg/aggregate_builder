module AggregateBuilder
  class FieldBuilders::ObjectFieldBuilder
    class << self

      def build(field, field_value, object, config, methods_context)
        hash = field_value
        existing_object = object.send(field.field_name)
        if existing_object && delete?(hash, field, config)
          object.send("#{field_name}=", nil)
        elsif existing_object
          primary_key = field.build_options[:primary_key] || config.primary_key
          hash.delete(primary_key) || hash.delete(primary_key.to_s)

          field.build_options[:builder].new.update(existing_object, hash)
        else
          object.send("#{field.field_name}=", field.build_options[:builder].new.build(hash))
        end
      end

      private

      def delete?(hash, field, config)
        deletable = field.build_options[:deletable]
        deletable ||= true
        if deletable
          delete_key = field.build_options[:delete_key] || config.delete_key
          delete_key_processing = field.build_options[:delete_key_processing] || config.delete_key_processing
          delete_key_processing.call(hash[delete_key])
        end
      end

    end
  end
end
