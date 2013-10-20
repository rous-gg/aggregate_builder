module AggregateBuilder
  module Metadata
    class BuildConfig
      LOG_TYPES                       = [:exception, :logging, :ignoring]
      DEFAULT_LOG_TYPE                = :exception

      DEFAULT_PRIMARY_KEY             = :id
      DEFAULT_PRIMARY_KEY_PROCESSING  = ->(key_value) { key_value.to_s.to_i }

      DEFAULT_DELETE_KEY              = :_destroy
      DEFAULT_DELETE_KEY_PROCESSING   = ->(flag) { flag == true || flag == 'true' }


      attr_accessor   :primary_key, :primary_key_processing
      attr_accessor   :delete_key,  :delete_key_processing
      attr_accessor   :log_type

      def initialize
        @log_type                = DEFAULT_LOG_TYPE
        @primary_key             = DEFAULT_PRIMARY_KEY
        @primary_key_processing  = DEFAULT_PRIMARY_KEY_PROCESSING
        @delete_key              = DEFAULT_DELETE_KEY
        @delete_key_processing   = DEFAULT_DELETE_KEY_PROCESSING
      end

      def configure(&config_block)
        Metadata::DSL::BuildConfigDSL.new(self).instance_exec(&config_block)
      end

      def log_type=(type)
        raise ArgumentError, "log_type should be one of #{LOG_TYPES}" unless LOG_TYPES.include?(type)
        @log_type = type
      end

      def primary_key=(key)
        raise ArgumentError, "primary_key should be a Symbol" unless key.is_a?(Symbol)
        @primary_key = key
      end

      def delete_key=(key)
        raise ArgumentError, "delete_key should be a Symbol" unless key.is_a?(Symbol)
        @delete_key = key
      end

      def logging?
        @log_type == :logging
      end

      def exception?
        @log_type == :exception
      end

      def ignoring?
        @log_type == :ignoring
      end

      def clone
        clonned = self.class.new
        clonned.instance_variable_set(:@log_type, @log_type)
        clonned.instance_variable_set(:@primary_key, @primary_key.is_a?(Symbol) ? @primary_key : @primary_key.clone)
        clonned.instance_variable_set(:@primary_key_processing, @primary_key_processing.clone)
        clonned.instance_variable_set(:@delete_key, @delete_key)
        clonned.instance_variable_set(:@delete_key_processing, @delete_key_processing)
        clonned
      end

    end
  end
end
