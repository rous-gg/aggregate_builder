module AggregateBuilder
  class AttributesProcessor
    def initialize(builder_rules, builder)
      @builder_rules = builder_rules
      @builder       = builder
    end

    def process(attributes, entity)
      keys = extract_attributes_keys(attributes)
      @attributes = attributes
      @entity     = entity
      processed_attributes = {}
      @builder_rules.fields_collection.each do |field|
        field_key = find_key_or_alias(field, keys)
        value = process_attribute(field, field_key)
        processed_attributes[field.field_name] = value
      end
      processed_attributes
    end

    private

    def extract_attributes_keys(attributes)
      attributes.keys.map do |key|
        rescue_convert_key_to_symbol(key)
      end.reject(&:nil?).uniq
    end

    def rescue_convert_key_to_symbol(key)
      key.to_sym
    rescue => e
      nil
    end

    def find_key_or_alias(field, keys)
      field.keys.detect do |key|
        keys.include?(key)
      end
    end

    def process_attribute(field, field_key)
      if !field_key && field.required?
        log_missing_attribute(field)
      end

      value = @builder.instance_exec(
        @entity,
        @attributes,
        &field.value_processor
      ) if field.has_processing?

      field_key ||= field.field_name
      clean_value(field, field_key, value)
    end

    def clean_value(field, field_key, value)
      value ||= @attributes[field_key] || @attributes[field_key.to_s]
      klass = type_caster_class(field)
      type_caster_class(field).clean(value)
    end

    def type_caster_class(field)
      if field.type.is_a?(Class)
        field.type
      else
        type = field.type.to_s.split('_').each(&:capitalize!).join("")
        Object.const_get("AggregateBuilder").const_get("TypeCasters").const_get("#{type}Caster")
      end
    end

    def log_missing_attribute(field)
      if @builder_rules.warn_level?
        p "Warning: Required field #{field.field_name} is missing for #{@builder.class} builder"
      elsif @builder_rules.error_level?
        raise Errors::RequireAttributeMissingError, "Required field #{field.field_name} is missing for #{@builder.class} builder"
      end
    end
  end
end
