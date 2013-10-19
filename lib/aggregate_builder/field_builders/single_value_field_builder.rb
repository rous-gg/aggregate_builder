module AggregateBuilder
  class FieldBuilders::SingleValueFieldBuilder

    def self.build(field_name, field_value, entity, build_options, methods_context)
      if build_options[:immutable]
        if entity.send(field_name) != field_value
          raise Errors::ImmutableFieldError, "Field '#{field_name}' can not be changed"
        end
      else
        if !build_options[:ignore]
          entity.send("#{field_name}=", field_value)
        end
      end
    end

  end
end
