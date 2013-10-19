module AggregateBuilder
  class ErrorsNotifier
    def initialize(log_type)
      @log_type = log_type
    end

    def notify_casting_error(exception)
      if @log_type == :log
        p exception.message
        nil
      elsif @log_type == :exception
        raise exception
      elsif @builder_rules == :ignore
        nil
      end
    end

    def notify_undefined_field_given(field_name)
      message = "Unexpected field with name '#{field_name}'"
      if @log_type == :log
        p "WARNING: #{message}"
      elsif @log_type == :exception
        raise Errors::UnexpectedAttribute, message
      elsif @log_type == :ignore
        nil
      end
    end

  end
end
