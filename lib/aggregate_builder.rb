require 'active_support/core_ext/class/attribute.rb'
require 'active_support/concern.rb'
require 'active_support/inflector/methods.rb'
require 'active_support/core_ext/string/inflections.rb'

require "aggregate_builder/version"
require "aggregate_builder/errors"

require "aggregate_builder/type_casters/single_value_builder"
require "aggregate_builder/type_casters/multiple_value_builder"
require "aggregate_builder/type_casters/string_caster"
require "aggregate_builder/type_casters/boolean_caster"
require "aggregate_builder/type_casters/float_caster"
require "aggregate_builder/type_casters/date_caster"
require "aggregate_builder/type_casters/integer_caster"
require "aggregate_builder/type_casters/time_caster"
require "aggregate_builder/type_casters/array_of_hashes_caster"
require "aggregate_builder/type_casters/hash_caster"

require "aggregate_builder/errors_notifier"
require "aggregate_builder/attributes_caster"
require "aggregate_builder/children_caster"
require "aggregate_builder/buildable"

require "aggregate_builder/metadata/field_metadata"
require "aggregate_builder/metadata/nested_field_metadata"
require "aggregate_builder/metadata/fields_collection"

require "aggregate_builder/metadata/callback_metadata"
require "aggregate_builder/metadata/callbacks_collection"

require "aggregate_builder/metadata/config_rules"
require "aggregate_builder/metadata/config_dsl"

require "aggregate_builder/metadata/children_rules"
require "aggregate_builder/metadata/child_metadata"
require "aggregate_builder/metadata/children_dsl"
require "aggregate_builder/metadata/builder_rules"

require "aggregate_builder/metadata/dsl"

module AggregateBuilder
end
