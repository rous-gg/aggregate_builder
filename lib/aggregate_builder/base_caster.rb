module AggregateBuilder
  class BaseCaster
    def extract_attributes_keys(attributes)
      attributes.keys.map do |key|
        rescue_convert_key_to_symbol(key)
      end.reject(&:nil?).uniq
    end

    def rescue_convert_key_to_symbol(key)
      key.to_sym
    rescue => e
      nil
    end

    def find_key_or_alias(field, keys)
      field.keys.detect do |key|
        keys.include?(key)
      end
    end
  end
end
