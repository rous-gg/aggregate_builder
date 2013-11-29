module AggregateBuilder
  module FieldBuilders

    def self.field_builder_by_name(name)
      AggregateBuilder::FieldBuilders.const_get("#{name.to_s.camelize}FieldBuilder", false)
    rescue NameError => e
      nil
    end

  end
end
