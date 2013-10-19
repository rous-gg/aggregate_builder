module AggregateBuilder
  module Metadata
    class BuildConfig
      LOG_TYPES            = [:exception, :log, :ignore]
      DEFAULT_SEARCH_BLOCK = Proc.new {|entity, attrs| entity.id && entity.id == attrs[:id] }
      DEFAULT_DELETE_BLOCK = Proc.new {|attrs| attrs[:_destroy] == true }
      DEFAULT_LOG_TYPE     = :exception

      attr_accessor   :search_block
      attr_accessor   :delete_block
      attr_accessor   :log_type

      def initialize
        @search_block = DEFAULT_SEARCH_BLOCK
        @delete_block = DEFAULT_DELETE_BLOCK
        @log_type     = DEFAULT_LOG_TYPE
      end

      def log_type=(type)
        raise ArgumentError, "log type should be one of #{LOG_TYPES}" unless LOG_TYPES.include?(type)
        @log_type = type
      end

      def clone
        clonned = self.class.new
        clonned.instance_variable_set(:@search_block, @search_block.clone)
        clonned.instance_variable_set(:@delete_block, @delete_block.clone)
        clonned.instance_variable_set(:@log_type,     @log_type)
        clonned
      end

    end
  end
end