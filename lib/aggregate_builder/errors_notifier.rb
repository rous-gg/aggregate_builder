module AggregateBuilder
  class ErrorsNotifier
    def initialize(builder_rules)
      @builder_rules = builder_rules
    end

    def notify_casting_error(exception)
      if @builder_rules.warn_level?
        p exception.message
        nil
      elsif @builder_rules.error_level?
        raise exception
      elsif @builder_rules.silent_level?
        nil
      end
    end

    def notify_nested_array_type_error(field_name)
      message = "You should provide array of hashes for #{field_name}"
      if @builder_rules.warn_level?
        p "WARNING: #{message}"
      elsif @builder_rules.error_level?
        raise Errors::AssociationParamsError, message
      elsif @builder_rules.silent_level?
        nil
      end
    end

    def notify_nested_hash_type_error(field_name)
      message = "You should provide hash for #{field_name}"
      if @builder_rules.warn_level?
        p "WARNING: #{message}"
      elsif @builder_rules.error_level?
        raise Errors::AssociationParamsError, message
      elsif @builder_rules.silent_level?
        nil
      end
    end

    def notify_undefined_field_given(field_name)
      message = "Unexpected field with name '#{field_name}'"
      if @builder_rules.warn_level?
        p "WARNING: #{message}"
      elsif @builder_rules.error_level?
        raise Errors::UnexpectedAttribute, message
      elsif @builder_rules.silent_level?
        nil
      end
    end

  end
end
