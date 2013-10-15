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
1. Implement search_key, delete_key configs. Add tests for that
2. Remove duplication in error_notifier
3. Because now we iterate through attributes, we can't set default value
   in the field block (because if attribute is missing then field block won't be executed)
   Find a way to set default value if attribute is missing. It's possible in before_build callback
Discuss:
1. rename FieldMetadata to Field, NestedFieldMetadata to NestedField
