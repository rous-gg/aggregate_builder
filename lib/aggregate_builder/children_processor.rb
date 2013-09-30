module AggregateBuilder
  class ChildrenProcessor < BaseProcessor
    def initialize(builder_rules)
      @builder_rules = builder_rules
    end

    def process(entity, attributes)
      @attributes = attributes
      @entity     = entity
      attributes_keys = extract_attributes_keys(attributes)
      @builder_rules.children_rules.each do |child_metadata|
        raise ArgumentError, "You should define builder class for #{child_metadata.child_name}" if !child_metadata.builder
        child_key = find_key_or_alias(child_metadata, attributes_keys)
        if child_key
          association_attributes = attributes[child_key] || attributes[child_key.to_s]
          next if !association_attributes

          children_or_child = entity.send(child_metadata.child_name)

          if children_or_child.respond_to?(:each)
            if !(association_attributes.is_a?(Array) && association_attributes.all? {|a| a.is_a?(Hash)})
              raise Errors::AssociationParamsError, "You should provide array of hashes for #{child_metadata.child_name}"
            end
            association_attributes.each do |attrs|
              child = find_child(children_or_child, attrs)

              if child && should_delete?(child_metadata, attrs)
                children_or_child.delete_if do |child_entity|
                  child_entity == child
                end
              else
                builder = child_metadata.builder.new
                entity.send(child_metadata.child_name) << builder.build(child, attrs)
              end
            end
          else
            if !association_attributes.is_a?(Hash)
              raise Errors::AssociationParamsError, "You should provide hash for #{child_metadata.child_name}"
            end
            if should_delete?(child_metadata, association_attributes)
              entity.send("#{child_metadata.child_name}=", nil)
            else
              builder = child_metadata.builder.new
              entity.send(
                "#{child_metadata.child_name}=",
                builder.build(children_or_child, association_attributes)
              )
            end
          end
        end
      end
    end

    private

    def find_child(children, association_attributes)
      search_key = @builder_rules.config_rules.search_key
      search_key_value = association_attributes[search_key] || association_attributes[search_key.to_sym]
      if search_key_value
        search_key_value = @builder_rules.config_rules.search_key_block.call search_key_value
        children.detect do |child|
          child.send(search_key) == search_key_value
        end
      end
    end

    def should_delete?(child_metadata, association_attributes)
      if child_metadata.deletable?
        delete_key = @builder_rules.config_rules.delete_key
        value = association_attributes[delete_key] || association_attributes[delete_key.to_s]
        if value
          @builder_rules.config_rules.delete_key_block.call(value)
        end
      end
    end

  end
end
