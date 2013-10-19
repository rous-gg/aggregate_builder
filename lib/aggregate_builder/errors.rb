module AggregateBuilder
  module Errors
    class AggregateBuilderError              < StandardError; end

    class UndefinedRootClassError < AggregateBuilderError; end
    class UnexpectedAttribute     < AggregateBuilderError; end
    class TypeCastingError        < AggregateBuilderError; end
    class ImmutableFieldError     < AggregateBuilderError; end
  end
end
