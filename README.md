# AggregateBuilder

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'aggregate_builder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aggregate_builder

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# TODO
Discuss:
1. rename TypeCasters to Types
2. rename build_chilren to nested_field, because FieldMetadata and ChildMetadata have common logic:
    build_children :wheels do
      builder WheelBuilder
      reject_if do |entity, attributes|
        attributes[:manufacturer].nil?
      end
    end

    nested_field :wheels, builder: WheelBuilder,
                          type: :array, # add this type
                          deletable: true,
                          reject_if: -> {|entity, attributes} attributes[:manufacturer].nil? }
    Also, passing a block into nested_field will preprocess children attributes, then
    before_children_build callback will be unnnecessary
3. rename FieldMetadata to Field, ChildMetadata to (ChildField < Field)
4. iteration through attributes instead of fields_collection
