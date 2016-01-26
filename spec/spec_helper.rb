$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'obelix'

require 'simplecov'

SimpleCov.start unless ENV["NO_COVERAGE"]
