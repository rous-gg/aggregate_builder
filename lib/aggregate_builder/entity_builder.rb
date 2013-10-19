module AggregateBuilder
  class EntityBuilder

    def initialize(builder_rules, attributes, entity, methods_context)
      @builder_rules   = builder_rules
      @attributes      = attributes
      @entity          = entity
      @methods_context = methods_context
      @errors_notifier = ErrorsNotifier.new(@builder_rules)
    end

    def build
      @attributes.each do |field_name, field_value|
        field = @builder_rules.fields_collection.find(field_name)
        unless field
          @errors_notifier.notify_undefined_field_given(field_name)
          next
        end
        field.build(field_value, @entity, @methods_context)
      end

    end


  end
end
