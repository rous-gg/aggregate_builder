module AggregateBuilder
  class ErrorsNotifier
    def initialize(builder_rules)
      @builder_rules = builder_rules
    end

    def notify_missing_attribute(field, builder)
      if @builder_rules.warn_level?
        p "Warning: Required field #{field.field_name} is missing for #{builder.class} builder"
      elsif @builder_rules.error_level?
        raise Errors::RequireAttributeMissingError, "Required field #{field.field_name} is missing for #{builder.class} builder"
      end
    end

    def notify_casting_error(exception)
      if @builder_rules.silent_level?
        nil
      elsif @builder_rules.warn_level?
        p exception.message
        nil
      elsif @builder_rules.error_level?
        raise exception
      end
    end

  end
end
