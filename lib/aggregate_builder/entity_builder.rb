module AggregateBuilder
  class EntityBuilder

    def initialize(build_rules, methods_context)
      @build_rules     = build_rules
      @methods_context = methods_context
      @errors_notifier = ErrorsNotifier.new(@build_rules.config.log_type)
    end

    def build(entity, attributes)
      attributes.each do |field_name, field_value|
        field = @build_rules.fields_collection.find(field_name)
        unless field
          @errors_notifier.notify_undefined_field_given(field_name, @methods_context.class)
          next
        end
        try_build(entity, field, field_value)
      end
      entity
    end

    # implement one day
    def update(entity, attributes)
      build(entity, attributes)
    end

    # implement one day
    def patch(entity, attributes)
      build(entity, attributes)
    end

    private

    def try_build(entity, field, field_value)
      field_value = field.type_caster.cast(field_value)
      field.field_builder.build(field, field_value, entity, @build_rules.config, @methods_context)
    rescue Errors::TypeCastingError => e
      @errors_notifier.notify_type_casting_error(e)
    end


  end
end
