module AggregateBuilder
  class ErrorsNotifier
    def initialize(config)
      @config = config
    end

    def notify_type_casting_error(exception)
      if @config.logging?
        p exception.message
        nil
      elsif @config.exception?
        raise exception
      elsif @builder_rules == :ignore
        nil
      end
    end

    def notify_undefined_field_given(field_name, context_class)
      message = "Unexpected field with name '#{field_name}' in #{context_class}"
      if @config.logging?
        p "WARNING: #{message}"
      elsif @config.exception?
        raise Errors::UnexpectedAttribute, message
      elsif @log_type == :ignore
        nil
      end
    end

  end
end
