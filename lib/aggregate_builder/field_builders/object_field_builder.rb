module AggregateBuilder
  class FieldBuilders::ObjectFieldBuilder
    DEFAULT_DELETE_KEY = :_delete
    class << self

      def build(field_name, field_value, entity, build_options, methods_context)
        hash = field_value
        object = entity.send(field_name)
        if object && should_delete?(hash, build_options)
          entity.send("#{field_name}=", nil)
        else
          entity.send( "#{field_name}=", build_options[:object_builder].new.build(object, hash))
        end
      end

      private

      def should_delete?(hash, build_options)
        if build_options[:deletable]
          delete_key = DEFAULT_DELETE_KEY # TODO: make it configurable
          hash[delete_key] || hash[delete_key.to_s]
        end
      end

    end
  end
end
