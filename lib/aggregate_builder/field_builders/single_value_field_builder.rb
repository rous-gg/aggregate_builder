module AggregateBuilder::FieldBuilders
  class SingleValueFieldBuilder
    class << self

      def build(entity, field, field_value, methods_context, full_attributes)
        return if field.ignore?
        field_value = clean(field_value)
        if field.has_processing?
          methods_context.instance_exec(entity, full_attributes, &field.value_processor)
        end
        entity.send("#{field.field_name}=", field_value)
      end

      def clean(field_value)
        raise NotImplementedError, "Method 'clean' should be defined in your derived class"
      end

    end
  end
end
