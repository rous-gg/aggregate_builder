module AggregateBuilder
  class FieldBuilders::ArrayOfObjectsFieldBuilder
    class << self

      def build(field, field_value, entity, config, methods_context)
        check_build_options!(field.build_options)
        array_of_hashes = field_value
        array_of_hashes.each do |hash|
          unless reject?(hash, entity, field, methods_context)
            build_or_delete_object(field, hash, entity, config, methods_context)
          end
        end
      end

      private

      def check_build_options!(build_options)
        build_options ||= {}
        raise ArgumentError, "Builder should be specified in :build_options" unless build_options[:builder]
      end

      def build_or_delete_object(field, hash, entity, config, methods_context)
        children = entity.send(field.field_name) || []
        child = find_child(children, hash, field, config)

        if child && delete?(hash, field, config)
          delete_object_from_entity(entity, child, field)
        elsif child
          update_object(child, hash, field, config)
        else
          build_new_object(entity, hash, field, config)
        end
      end

      def delete?(hash, field, config)
        deletable = field.build_options[:deletable]
        deletable ||= true
        if deletable
          delete_key = field.build_options[:delete_key] || config.delete_key
          delete_key_processing = field.build_options[:delete_key_processing] || config.delete_key_processing
          delete_key_processing.call(hash[delete_key])
        end
      end

      def reject?(hash, entity, field, methods_context)
        if field.build_options[:reject_if]
          methods_context.instance_exec(hash, &field.build_options[:reject_if])
        else
          false
        end
      end

      def find_child(children, hash, field, config)
        primary_key = field.build_options[:primary_key] || config.primary_key
        primary_key_processing = field.build_options[:primary_key_processing] || config.primary_key_processing
        if primary_key.is_a?(Symbol)
          object_primary_key_block = ->(object, primary_key) { object.send(primary_key) }
          hash_primary_key_block   = ->(hash, primary_key) { hash[primary_key] || hash[primary_key] }
        else
          object_primary_key_block = ->(object, primary_key) { primary_key.map { |key| object.send(key) } }
          hash_primary_key_block   = ->(hash, primary_key) { primary_key.map { |key| hash[key] || hash[key.to_s] } }
        end
        children.detect do |child|
          primary_key_value = object_primary_key_block.call(child, primary_key)
          primary_key_value == primary_key_processing.call(hash_primary_key_block.call(hash, primary_key))
        end
      end

      def delete_object_from_entity(entity, child, field)
        entity.send(field.field_name).delete_if do |child_entity|
          child_entity == child
        end
      end

      def update_object(child, hash, field, config)
        primary_key = field.build_options[:primary_key] || config.primary_key
        hash.delete(primary_key) || hash.delete(primary_key.to_s)

        field.build_options[:builder].new.update(child, hash)
      end

      def build_new_object(entity, hash, field, config)
        primary_key = field.build_options[:primary_key] || config.primary_key
        hash.delete(primary_key) || hash.delete(primary_key.to_s)

        entity.send("#{field.field_name}=", []) unless entity.send(field.field_name)
        entity.send(field.field_name) << field.build_options[:builder].new.build(hash)
      end

    end
  end
end
