module AggregateBuilder
  class FieldBuilders::ArrayOfObjectsFieldBuilder
    class << self

      def build(field, field_value, object, config, methods_context)
        check_build_options!(field.options)
        field_value = cast(field.field_name, field_value)
        array_of_attributes = field_value

        object.send("#{field.field_name}=", []) unless object.send(field.field_name)

        delete_rejected_attributes!(array_of_attributes, field, methods_context)
        delete_marked_children!(array_of_attributes, object, field, config, methods_context)
        update_existing_children!(array_of_attributes, object, field, config, methods_context)
        build_new_children(array_of_attributes, object, field, config, methods_context)

        object
      end

      def cast(field_name, value)
        if value.nil?
          raise Errors::TypeCastingError, "#{field_name} can't be nil"
        end
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

      def delete_rejected_attributes!(array_of_attributes, field, methods_context)
        array_of_attributes.delete_if do |attributes|
          reject?(attributes, field, methods_context)
        end
      end

      def delete_marked_children!(array_of_attributes, object, field, config, methods_context)
        children = object.send(field.field_name)
        array_of_attributes.delete_if do |attributes|
          next unless delete?(attributes, field, config)
          child = find_child(children, attributes, field, config)
          child ? delete_child_from_object(object, child, field) : false
        end
      end

      def update_existing_children!(array_of_attributes, object, field, config, methods_context)
        children = object.send(field.field_name)
        to_update = {}
        array_of_attributes.delete_if do |attributes|
          child = find_child(children, attributes, field, config)
          child ? to_update[child] = attributes : false
        end
        builder = get_builder(field, methods_context)
        if builder.respond_to?(:update_all)
          builder.update_all(children, to_update.values)
        else
          to_update.each do |child, attributes|
            builder.update(child, attributes)
          end
        end
      end

      def build_new_children(array_of_attributes, object, field, config, methods_context)
        builder = get_builder(field, methods_context)
        if builder.respond_to?(:build_all)
         object.send("#{field.field_name}=", object.send(field.field_name) + builder.build_all(array_of_attributes))
        else
          array_of_attributes.each do |attrs|
            object.send(field.field_name) << builder.build(attrs)
          end
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

      def reject?(hash, field, methods_context)
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
        true
      end

      def get_builder(field, methods_context)
        if field.options[:builder].is_a?(Symbol)
          methods_context.send(field.options[:builder])
        elsif field.options[:builder].is_a?(Class)
          field.options[:builder].new
        end
      end
    end
  end
end
