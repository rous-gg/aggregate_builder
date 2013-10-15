module AggregateBuilder
  module TypeCasters
    class HashCaster < SingleValueBuilder
      class << self
        def clean(value)
          unless value.is_a?(Hash)
            raise Errors::TypeCastingError, "Expected to be a hash, got #{value}"
          end
          value
        end

        def build(entity, field, attrs, methods_context, full_attributes)
          child = entity.send(field.field_name)
          if should_delete?(field, attrs)
            entity.send("#{field.child_name}=", nil)
          else
            entity.send( "#{field.field_name}=", field.builder.build(child, attrs))
          end
        end

        def should_delete?(field, attrs)
          #if child_metadata.deletable?
            #delete_key = @builder_rules.config.delete_key
            #value = association_attributes[delete_key] || association_attributes[delete_key.to_s]
            #if value
              #@builder_rules.config.delete_key_block.call(value)
            #end
          #end
          if field.deletable?
            delete_key = :_delete
            attrs[delete_key] || attrs[delete_key.to_s]
          end
        end

      end
    end
  end
end
