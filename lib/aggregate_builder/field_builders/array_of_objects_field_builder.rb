module AggregateBuilder
  class FieldBuilders::ArrayOfObjectsFieldBuilder
    class << self

      def build(field_name, field_value, entity, build_options, methods_context)
        check_build_options!(build_options)
        array_of_hashes = field_value
        array_of_hashes.each do |hash|
          unless reject?(hash, entity, build_options, methods_context)
            build_or_delete_object(field_name, hash, entity, build_options, methods_context)
          end
        end
      end

      private

      def check_build_options!(build_options)
        build_options ||= {}
        raise ArgumentError, "Builder should be specified in :build_options" unless build_options[:builder]
      end

      def build_or_delete_object(field_name, hash, entity, build_options, methods_context)
        children = entity.send(field_name) || []
        child = find_child(children, hash, build_options)

        if child && delete?(hash, build_options)
          delete_object_from_entity(entity, child, field_name)
        elsif child
          update_object(child, hash, build_options)
        else
          build_new_object(entity, child, hash, field_name, build_options)
        end
      end

      def delete?(hash, build_options)
        if build_options[:deletable]
          build_options[:delete_block].call(hash)
        end
      end

      def reject?(hash, entity, build_options, methods_context)
        if build_options[:reject_if]
          methods_context.instance_exec(hash, &build_options[:reject_if])
        else
          false
        end
      end

      def find_child(children, hash, build_options)
        search_block = build_options[:search_block]
        children.detect do |child|
          search_block.call(child, hash)
        end
      end

      def delete_object_from_entity(entity, child, field_name)
        entity.send(field_name).delete_if do |child_entity|
          child_entity == child
        end
      end

      def update_object(child, hash, build_options)
        build_options[:builder].new.build(child, hash)
      end

      def build_new_object(entity, child, hash, field_name, build_options)
        entity.send("#{field_name}=", []) unless entity.send(field_name)
        entity.send(field_name) << build_options[:builder].new.build(child, hash)
      end

    end
  end
end
