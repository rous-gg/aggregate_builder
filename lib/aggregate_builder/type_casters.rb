module AggregateBuilder
  module TypeCasters

    def self.type_caster_by_name(name)
      "AggregateBuilder::TypeCasters::#{name.to_s.camelize}TypeCaster".constantize
    end

  end
end
