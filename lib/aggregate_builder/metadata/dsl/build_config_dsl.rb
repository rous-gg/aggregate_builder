module AggregateBuilder
  module Metadata
    module DSL
      class BuildConfigDSL
        def initialize(build_config)
          @build_config = build_config
        end

        def primary_key(key, &key_processing)
          @build_config.primary_key = key
          @build_config.primary_key_processing = key_processing
        end

        def delete_key(key, &key_processing)
          @build_config.delete_key = key
          @build_config.delete_key_processing = key_processing
        end

        def log_type(type)
          @build_config.log_type = type
        end
      end
    end
  end
end
