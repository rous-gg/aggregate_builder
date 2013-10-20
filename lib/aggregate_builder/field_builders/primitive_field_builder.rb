module AggregateBuilder
  class FieldBuilders::PrimitiveFieldBuilder

    def self.build(field, field_value, object, config, methods_context)
      object.send("#{field.field_name}=", field_value)
    end

  end
end
