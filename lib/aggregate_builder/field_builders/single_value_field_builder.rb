module AggregateBuilder
  class FieldBuilders::SingleValueFieldBuilder

    def self.build(field_name, field_value, entity, build_options, methods_context)
      entity.send("#{field_name}=", field_value)
    end

  end
end
