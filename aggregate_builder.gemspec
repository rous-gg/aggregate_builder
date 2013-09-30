# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aggregate_builder/version'

Gem::Specification.new do |spec|
  spec.name          = "aggregate_builder"
  spec.version       = AggregateBuilder::VERSION
  spec.authors       = ["Ruslan Gatiyatov", "Albert Gazizov", "Droid Labs LLC"]
  spec.email         = ["ruslan.gatiyatov@gmail.com", "deeper4k@gmail.com"]
  spec.description   = %q{Aggregate builder provides common DSL for building aggregates}
  spec.summary       = %q{Common aggregates building library}
  spec.homepage      = "http://droidlabs.pro"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
