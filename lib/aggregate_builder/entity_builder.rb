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
      @attributes.each do |attr_name, attr_value|
        field = @builder_rules.fields_collection.find(attr_name)
        unless field
          @errors_notifier.notify_undefined_field_given(attr_name)
          next
        end
        field.build(@entity, attr_value, @methods_context, @attributes, @builder_rules)
      end

    end


  end
end
