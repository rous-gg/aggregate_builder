module AggregateBuilder
  class AttributesCaster

    def initialize(builder_rules, builder, attributes, entity)
      @builder_rules = builder_rules
      @builder       = builder
      @attributes    = attributes
      @entity        = entity
      @errors_notifier = ErrorsNotifier.new(@builder_rules)
    end

    def cast
      casted_attributes = {}
      @builder_rules.fields_collection.each do |field|
        field_key = field.key_from(@attributes)
        casted_value = cast_attribute(field, field_key)
        if @attributes[field_key] || casted_value
          casted_attributes[field.field_name] = casted_value
        end
      end
      casted_attributes
    end

    def attribute_for(field_name)
      field = @builder_rules.fields_collection.find(field_name)
      if field
        alias_key = field.keys.detect do |key|
          @attributes.has_key?(key) || @attributes.has_key?(key.to_s)
        end
        if alias_key
          @attributes[alias_key] || @attributes[alias_key.to_s]
        end
      else
        raise Errors::FieldNotDefinedError, "Specified field is not defined"
      end
    end

    private

    def cast_attribute(field, field_key)
      if !field_key && field.required?(@builder, @entity, @attributes)
        @errors_notifier.notify_missing_attribute(field, @builder)
      end

      value = @builder.instance_exec(
        @entity,
        @attributes,
        &field.value_processor
      ) if field.has_processing?

      field_key ||= field.field_name
      cast_value(field, field_key, value)
    end

    def cast_value(field, field_key, value)
      value ||= @attributes[field_key] || @attributes[field_key.to_s]
      field.type_caster.clean(value)
    rescue => e
      @errors_notifier.notify_casting_error(e)
    end


  end
end
