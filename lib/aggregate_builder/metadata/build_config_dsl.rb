module AggregateBuilder
  module Metadata
    class BuildConfigDSL
      def initialize(build_config)
        @build_config = buld_config
      end

      def search_block(&block)
        @buld_config.search_block = block
      end

      def delete_block(&block)
        @buld_config.delete_block = block
      end

      def log_type(type)
        @buld_config.log_type = type
      end
    end
  end
end
