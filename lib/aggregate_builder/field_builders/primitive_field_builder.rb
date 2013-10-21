module AggregateBuilder
  class FieldBuilders::PrimitiveFieldBuilder

    def self.build(field, field_value, object, config, methods_context)
      field_value = cast(field_value)
      if field.options[:immutable]
        previous_field_value = object.send(field.field_name)
        if previous_field_value && previous_field_value != field_value
          raise Errors::ImmutableFieldError, "#{field.field_name} can not be changed, got #{field_value}"
        end
      end
      object.send("#{field.field_name}=", field_value)
    end

  end
end
