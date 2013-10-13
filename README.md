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
1. rename build_chilren to nested_field, because FieldMetadata and ChildMetadata have common logic:
    build_children :wheels do
      builder WheelBuilder
      reject_if do |entity, attributes|
        attributes[:manufacturer].nil?
      end
    end

    nested_field :wheels, builder: WheelBuilder,
                          deletable: true,
                          reject_if: -> {|entity, attributes} attributes[:manufacturer].nil? }
                          type: :array_of_hashes, # add this type
    Also, passing a block into nested_field will preprocess children attributes, then
    before_children_build callback will be unnnecessary
2. rename FieldMetadata to Field, ChildMetadata to (ChildField < Field)
3. remove raquired: true, cause it's usually is validation logic and validators do it anyway
4. iteration through attributes instead of fields_collection
5. rename TypeCasters to Types
