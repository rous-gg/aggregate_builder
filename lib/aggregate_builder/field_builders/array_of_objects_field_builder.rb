module AggregateBuilder
  class FieldBuilders::ArrayOfObjectsFieldBuilder
    class << self

      def build(field, field_value, object, config, methods_context)
        check_build_options!(field.options)
        field_value = cast(field.field_name, field_value)
        array_of_hashes = field_value
        array_of_hashes.each do |hash|
          unless reject?(hash, object, field, methods_context)
            build_or_delete_object(field, hash, object, config, methods_context)
          end
        end
      end

      def cast(field_name, value)
        unless value.is_a?(Array)
          raise Errors::TypeCastingError, "Expected to be an array, got #{value.inspect} for #{field_name}"
        end
        unless value.all?{|i| i.is_a?(Hash) }
          raise Errors::TypeCastingError, "Expected to be an array of hashes, got #{value.inspect} for #{field_name}"
        end
        value
      end

      private

      def check_build_options!(build_options)
        build_options ||= {}
        raise ArgumentError, "Builder should be specified" unless build_options[:builder]
        raise ArgumentError, "You should provide class or Symbol" unless build_options[:builder].is_a?(Class) || build_options[:builder].is_a?(Symbol)
      end

      def build_or_delete_object(field, hash, object, config, methods_context)
        children = object.send(field.field_name) || []
        child = find_child(children, hash, field, config)

        if child && delete?(hash, field, config)
          delete_child_from_object(object, child, field)
        elsif child
          update_object(child, hash, field, config, methods_context)
        else
          build_new_object(object, hash, field, config, methods_context)
        end
      end

      def delete?(hash, field, config)
        deletable = field.options[:deletable]
        deletable ||= true
        if deletable
          delete_key = field.options[:delete_key] || config.delete_key
          if delete_key.is_a?(Symbol)
            delete_key = ->(hash) { hash[delete_key] == true || hash[delete_key] == 'true' }
          end
          delete_key.call(hash)
        end
      end

      def reject?(hash, object, field, methods_context)
        if field.options[:reject_if]
          methods_context.instance_exec(hash, &field.options[:reject_if])
        else
          false
        end
      end

      def find_child(children, hash, field, config)
        primary_key = field.options[:primary_key] || config.primary_key
        if primary_key.is_a?(Symbol)
          primary_key_symbol = primary_key
          primary_key = ->(entity, hash) { entity.send(primary_key_symbol) && entity.send(primary_key_symbol) == hash[primary_key_symbol] }
        end
        children.detect do |child|
          primary_key.call(child, hash)
        end
      end

      def delete_child_from_object(object, child, field)
        object.send(field.field_name).delete_if do |child_object|
          child_object == child
        end
      end

      def update_object(child, hash, field, config, methods_context)
        builder(field, methods_context).update(child, hash)
      end

      def build_new_object(object, hash, field, config, methods_context)
        object.send("#{field.field_name}=", []) unless object.send(field.field_name)
        object.send(field.field_name) << builder(field, methods_context).build(hash)
      end

      def builder(field, methods_context)
        if field.options[:builder].is_a?(Symbol)
          methods_context.send(field.options[:builder])
        elsif field.options[:builder].is_a?(Class)
          field.options[:builder].new
        end
      end
    end
  end
end
