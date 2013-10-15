module AggregateBuilder
  module FieldBuilders

    def self.find_field_builder_by_name(field_builder_name)
      "AggregateBuilder::FieldBuilders::#{field_builder_name.to_s.camelize}FieldBuilder".constantize
    end

  end
end
