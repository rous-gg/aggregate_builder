require 'active_support/core_ext/class/attribute.rb'
require 'active_support/concern.rb'
require 'active_support/inflector/methods.rb'
require 'active_support/core_ext/string/inflections.rb'

require "aggregate_builder/version"
require "aggregate_builder/errors"

require "aggregate_builder/field_builders"
require "aggregate_builder/field_builders/single_value_field_builder"
require "aggregate_builder/field_builders/multiple_value_field_builder"
require "aggregate_builder/field_builders/string_field_builder"
require "aggregate_builder/field_builders/boolean_field_builder"
require "aggregate_builder/field_builders/float_field_builder"
require "aggregate_builder/field_builders/date_field_builder"
require "aggregate_builder/field_builders/integer_field_builder"
require "aggregate_builder/field_builders/time_field_builder"
require "aggregate_builder/field_builders/array_of_hashes_field_builder"
require "aggregate_builder/field_builders/hash_field_builder"

require "aggregate_builder/errors_notifier"
require "aggregate_builder/entity_builder"
require "aggregate_builder/buildable"

require "aggregate_builder/metadata/field_metadata"
require "aggregate_builder/metadata/nested_field_metadata"
require "aggregate_builder/metadata/fields_collection"

require "aggregate_builder/metadata/callback_metadata"
require "aggregate_builder/metadata/callbacks_collection"

require "aggregate_builder/metadata/config_rules"
require "aggregate_builder/metadata/config_dsl"

require "aggregate_builder/metadata/builder_rules"

require "aggregate_builder/metadata/dsl"

module AggregateBuilder
end
