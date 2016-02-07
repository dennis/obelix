require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

require 'simplecov'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

SimpleCov.start unless ENV["NO_COVERAGE"]

require 'obelix'

