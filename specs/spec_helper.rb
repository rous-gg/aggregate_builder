require 'rubygems'
require 'bundler/setup'
require 'debugger'

require 'aggregate_builder'

RSpec.configure do |config|
  config.order = "random"
  config.color_enabled = true
  config.formatter = :documentation #:progress, :html, :textmate
end
