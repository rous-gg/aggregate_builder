module AggregateBuilder
  class FieldBuilders::SingleValueFieldBuilder

    def self.build(field, field_value, entity, config, methods_context)
      entity.send("#{field.field_name}=", field_value)
    end

  end
end
