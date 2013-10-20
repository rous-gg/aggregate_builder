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
1. Discuss update, patch methods according to JSON PATCH RFC (http://tools.ietf.org/html/rfc6902)
2. Discuss removing build_options key
3. Think about search_key, delete_key, removing keys from hash makes inherited_spec fail,
   propably need to introduce immutable option

4. Add test when deletable is false
5. Add tests when logging type is :loggin and :ignore
6. Add test with reject_if
7. Probably move all field builders specific tests to their own files
