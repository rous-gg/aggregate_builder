module AggregateBuilder
  class ErrorsNotifier
    def initialize(builder_rules)
      @builder_rules = builder_rules
    end

    def notify_missing_attribute(field, builder)
      message = "Required field #{field.field_name} is missing for #{builder.class} builder"
      if @builder_rules.warn_level?
        p "Warning: #{mesage}"
      elsif @builder_rules.error_level?
        raise Errors::RequireAttributeMissingError, message
      elsif @builder_fules.silent_level?
        nil
      end
    end

    def notify_casting_error(exception)
      if @builder_rules.warn_level?
        p exception.message
        nil
      elsif @builder_rules.error_level?
        raise exception
      elsif @builder_fules.silent_level?
        nil
      end
    end

    def notify_nested_array_type_error(field_name)
      message = "You should provide array of hashes for #{field_name}"
      if @builder_rules.warn_level?
        p "WARNING: #{message}"
      elsif @builder_rules.error_level?
        raise Errors::AssociationParamsError, message
      elsif @builder_fules.silent_level?
        nil
      end
    end

    def notify_nested_hash_type_error(field_name)
      message = "You should provide hash for #{field_name}"
      if @builder_rules.warn_level?
        p "WARNING: #{message}"
      elsif @builder_rules.error_level?
        raise Errors::AssociationParamsError, message
      elsif @builder_fules.silent_level?
        nil
      end
    end

  end
end
