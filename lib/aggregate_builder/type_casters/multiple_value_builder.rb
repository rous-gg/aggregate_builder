module AggregateBuilder
  module TypeCasters
    class MultipleValueBuilder
      class << self
        def build(entity, field, field_values, methods_context, full_attributes)
          return if field.ignore?
          field_values = clean(field_values)
          field_values.each do |attrs|
            if should_build?(field, methods_context, entity, attrs)
              children = entity.send(field.field_name)
              child = find_child(children, attrs)

              if child && should_delete?(field, attrs)
                entity.send(field.field_name).delete_if do |child_entity|
                  child_entity == child
                end
              elsif child
                field.builder.build(child, attrs)
              else
                entity.send(field.field_name) << field.builder.build(child, attrs)
              end
            end
          end
        end

        def find_child(children, association_attributes)
          search_key = :id
          search_key_value = association_attributes[search_key] || association_attributes[search_key.to_sym]
          if search_key_value
            #search_key_value = @builder_rules.config.search_key_block.call search_key_value
            children.detect do |child|
              child.send(search_key) == search_key_value
            end
          end
        end

        def should_delete?(field, attrs)
          if field.deletable?
            delete_key = :_delete
            attrs[delete_key] || attrs[delete_key.to_s]
          end
        end

        def should_build?(field, methods_context, entity, attributes)
          if field.reject_if_block
            !methods_context.instance_exec(entity, attributes, &field.reject_if_block)
          else
            true
          end
        end

        def clean(field_value)
          raise NotImplementedError, "Method 'clean' should be defined in your derived class"
        end

      end
    end
  end
end
