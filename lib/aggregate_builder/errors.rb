module AggregateBuilder
  module Errors
    class UndefinedRootClassError < StandardError; end
    class RequireAttributeMissingError < StandardError; end
    class TypeCastingError < StandardError; end
  end
end
