module AggregateBuilder
  class FieldBuilders::ObjectFieldBuilder
    class << self

      def build(field_name, field_value, entity, build_options, methods_context)
        hash = field_value
        object = entity.send(field_name)
        if object && should_delete?(hash, build_options)
          entity.send("#{field_name}=", nil)
        else
          entity.send( "#{field_name}=", build_options[:builder].new.build(object, hash))
        end
      end

      private

      def should_delete?(hash, build_options)
        if build_options[:deletable]
          build_options[:delete_block].call(hash)
        end
      end

    end
  end
end
