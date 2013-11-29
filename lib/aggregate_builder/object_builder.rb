module AggregateBuilder
  class ObjectBuilder

    def initialize(build_rules, config, methods_context)
      @build_rules     = build_rules
      @config          = config
      @methods_context = methods_context
      @errors_notifier = ErrorsNotifier.new(config)
    end

    def build(object, attributes)
      attributes.each do |field_name, field_value|
        field = @build_rules.fields_collection.find(field_name)
        unless field
          @errors_notifier.notify_undefined_field_given(field_name, @methods_context.class)
          next
        end
        try_build(object, field, field_value)
      end
      object
    end

    def update(object, attributes)
      build(object, attributes)
    end

    private

    def try_build(object, field, field_value)
      field.field_builder(@methods_context).build(field, field_value, object, @config, @methods_context)
    rescue Errors::TypeCastingError => e
      @errors_notifier.notify_type_casting_error(e)
    end


  end
end
