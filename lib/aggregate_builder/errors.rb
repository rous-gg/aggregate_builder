module AggregateBuilder
  module Errors
    class UndefinedRootClassError < StandardError; end
    class RequireAttributeMissingError < StandardError; end
    class TypeCastingError < StandardError; end
    class AssociationParamsError < StandardError; end
    class FieldNotDefinedError < StandardError; end
  end
end
