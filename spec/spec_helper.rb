$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'simplecov'

SimpleCov.start unless ENV["NO_COVERAGE"]

Dir["./spec/support/**/*.rb"].sort.each { |f| require f}

require 'obelix'

