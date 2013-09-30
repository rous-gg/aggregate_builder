require "aggregate_builder/version"
require "aggregate_builder/errors"

require "aggregate_builder/type_casters/string_caster"
require "aggregate_builder/type_casters/boolean_caster"
require "aggregate_builder/type_casters/float_caster"
require "aggregate_builder/type_casters/date_caster"
require "aggregate_builder/type_casters/integer_caster"
require "aggregate_builder/type_casters/time_caster"

require "aggregate_builder/attributes_processor"
require "aggregate_builder/buildable"
require "aggregate_builder/metadata/field_metadata"
require "aggregate_builder/metadata/fields_collection"
require "aggregate_builder/metadata/callback_metadata"
require "aggregate_builder/metadata/callbacks_collection"
require "aggregate_builder/metadata/children_collection"
require "aggregate_builder/metadata/children_rules"
require "aggregate_builder/metadata/child_metadata"
require "aggregate_builder/metadata/children_dsl"
require "aggregate_builder/metadata/builder_rules"
require "aggregate_builder/metadata/dsl"


module AggregateBuilder
end
