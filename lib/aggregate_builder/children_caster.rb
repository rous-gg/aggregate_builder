module AggregateBuilder
  class ChildrenCaster

    def initialize(builder_rules, builder, attributes, entity)
      @builder_rules = builder_rules
      @builder       = builder
      @attributes    = attributes
      @entity        = entity
      @errors_notifier = ErrorsNotifier.new(@builder_rules)
    end

    def cast
      @builder_rules.children_rules.each do |child_metadata|
        raise ArgumentError, "You should define builder class for #{child_metadata.child_name}" if !child_metadata.builder
        if child_key = child_metadata.key_from(@attributes)
          association_attributes = @attributes[child_key] || @attributes[child_key.to_s]
          next if !association_attributes

          children_or_child = @entity.send(child_metadata.child_name)

          if children_or_child.respond_to?(:each)
            if !(association_attributes.is_a?(Array) && association_attributes.all? {|a| a.is_a?(Hash)})
              @errors_notifier.notify_nested_array_type_error(child_metadata.child_name)
              next
            end
            cast_array(children_or_child, child_metadata, association_attributes)
          else
            if !association_attributes.is_a?(Hash)
              @errors_notifier.notify_nested_hash_type_error(child_metadata.child_name)
              next
            end
            cast_hash(children_or_child, child_metadata, association_attributes)
          end
        end
      end
    end

    private

    def cast_array(children, child_metadata, association_attributes)
      association_attributes.each do |attrs|
        child = find_child(children, attrs)

        if should_build?(child_metadata, attrs)
          if child && should_delete?(child_metadata, attrs)
            @entity.send(child_metadata.child_name).delete_if do |child_entity|
              child_entity == child
            end
          else
            builder = get_builder(child_metadata)
            @entity.send(child_metadata.child_name) << builder.build(child, attrs)
          end
        end
      end
    end

    def cast_hash(child, child_metadata, association_attributes)
      if should_build?(child_metadata, association_attributes)
        if should_delete?(child_metadata, association_attributes)
          @entity.send("#{child_metadata.child_name}=", nil)
        else
          builder = get_builder(child_metadata)
          @entity.send(
            "#{child_metadata.child_name}=",
            builder.build(child, association_attributes)
          )
        end
      end
    end

    def get_builder(child_metadata)
      if child_metadata.builder.is_a?(Class)
        child_metadata.builder.new
      elsif child_metadata.builder.is_a?(Symbol)
        @builder.send(child_metadata.builder)
      end
    end

    def find_child(children, association_attributes)
      search_key = @builder_rules.config.search_key
      search_key_value = association_attributes[search_key] || association_attributes[search_key.to_sym]
      if search_key_value
        search_key_value = @builder_rules.config.search_key_block.call search_key_value
        children.detect do |child|
          child.send(search_key) == search_key_value
        end
      end
    end

    def should_delete?(child_metadata, association_attributes)
      if child_metadata.deletable?
        delete_key = @builder_rules.config.delete_key
        value = association_attributes[delete_key] || association_attributes[delete_key.to_s]
        if value
          @builder_rules.config.delete_key_block.call(value)
        end
      end
    end

    def should_build?(child_metadata, association_attributes)
      if child_metadata.reject_if_block
        !@builder.instance_exec(
          @entity,
          association_attributes,
          &child_metadata.reject_if_block
        )
      else
        true
      end
    end

  end
end
