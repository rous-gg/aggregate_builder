require 'active_support/core_ext/class/attribute.rb'
require 'active_support/concern.rb'
require 'active_support/inflector/methods.rb'
require 'active_support/core_ext/string/inflections.rb'

require "aggregate_builder/version"
require "aggregate_builder/errors"

# Type casters
require "aggregate_builder/type_casters"
require "aggregate_builder/type_casters/string_type_caster"
require "aggregate_builder/type_casters/boolean_type_caster"
require "aggregate_builder/type_casters/float_type_caster"
require "aggregate_builder/type_casters/date_type_caster"
require "aggregate_builder/type_casters/integer_type_caster"
require "aggregate_builder/type_casters/time_type_caster"
require "aggregate_builder/type_casters/array_of_hashes_type_caster"
require "aggregate_builder/type_casters/hash_type_caster"

# Field builders
require "aggregate_builder/field_builders"
require "aggregate_builder/field_builders/single_value_field_builder"
require "aggregate_builder/field_builders/array_of_objects_field_builder"
require "aggregate_builder/field_builders/object_field_builder"

require "aggregate_builder/errors_notifier"
require "aggregate_builder/entity_builder"
require "aggregate_builder/buildable"

require "aggregate_builder/metadata/field_metadata"
require "aggregate_builder/metadata/fields_collection"

require "aggregate_builder/metadata/callback_metadata"
require "aggregate_builder/metadata/callbacks_collection"

require "aggregate_builder/metadata/config_rules"
require "aggregate_builder/metadata/config_dsl"

require "aggregate_builder/metadata/builder_rules"

require "aggregate_builder/metadata/build_rules_dsl"

module AggregateBuilder
end
