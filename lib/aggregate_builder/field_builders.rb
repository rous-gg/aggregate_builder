module AggregateBuilder
  module FieldBuilders

    def self.field_builder_by_name(name)
      "AggregateBuilder::FieldBuilders::#{name.to_s.camelize}FieldBuilder".constantize
    end

  end
end
