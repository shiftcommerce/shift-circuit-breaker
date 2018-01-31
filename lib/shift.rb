require "active_support/core_ext/module/delegation"
require "active_support/core_ext/string/inflections"
require "faraday"
require "logger"
require "newrelic_rpm"
require "sentry-raven"
require "timeout"

require "shift"
require "shift/circuit_breaker"

module Shift
end
