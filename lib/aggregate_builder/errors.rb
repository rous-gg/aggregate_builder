module AggregateBuilder
  module Errors
    class BuildError < StandardError; end
    class UndefinedRootClassError < BuildError; end
    class UnexpectedAttribute < BuildError; end
    class TypeCastingError < BuildError; end
    class AssociationParamsError < BuildError; end
    class FieldNotDefinedError < BuildError; end
  end
end
