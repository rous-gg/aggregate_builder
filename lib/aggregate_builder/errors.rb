module AggregateBuilder
  module Errors
    class AggregateBuilderError   < StandardError; end
    class AttributesError         < AggregateBuilderError; end
    class UndefinedRootClassError < AggregateBuilderError; end
    class UnexpectedAttribute     < AttributesError; end
    class TypeCastingError        < AttributesError; end
    class ImmutableFieldError     < AttributesError; end
  end
end
