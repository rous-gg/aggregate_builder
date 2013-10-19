module AggregateBuilder
  module Metadata
    class BuildConfigDSL
      def initialize(build_config)
        @build_config = build_config
      end

      def search_block(&block)
        @build_config.search_block = block
      end

      def delete_block(&block)
        @build_config.delete_block = block
      end

      def log_type(type)
        @build_config.log_type = type
      end
    end
  end
end
