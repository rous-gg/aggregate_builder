# Support libraries
require 'active_support/core_ext/class/attribute.rb'
require 'active_support/concern.rb'
require 'active_support/inflector/methods.rb'
require 'active_support/core_ext/string/inflections.rb'

# Aggregate Builder
require 'aggregate_builder/version'
require 'aggregate_builder/errors'

# Field builders
require 'aggregate_builder/field_builders'
require 'aggregate_builder/field_builders/primitive_field_builder'
require 'aggregate_builder/field_builders/array_of_objects_field_builder'
require 'aggregate_builder/field_builders/object_field_builder'
require 'aggregate_builder/field_builders/array_field_builder'
require 'aggregate_builder/field_builders/hash_field_builder'
require 'aggregate_builder/field_builders/string_field_builder'
require 'aggregate_builder/field_builders/boolean_field_builder'
require 'aggregate_builder/field_builders/float_field_builder'
require 'aggregate_builder/field_builders/date_field_builder'
require 'aggregate_builder/field_builders/integer_field_builder'
require 'aggregate_builder/field_builders/time_field_builder'

require 'aggregate_builder/errors_notifier'
require 'aggregate_builder/object_builder'
require 'aggregate_builder/buildable'

# Metadata
require 'aggregate_builder/metadata/field'
require 'aggregate_builder/metadata/fields_collection'
require 'aggregate_builder/metadata/callback'
require 'aggregate_builder/metadata/callbacks_collection'
require 'aggregate_builder/metadata/build_rules'
require 'aggregate_builder/metadata/build_config'
require 'aggregate_builder/metadata/dsl/build_rules_dsl'
require 'aggregate_builder/metadata/dsl/build_config_dsl'

module AggregateBuilder
end
