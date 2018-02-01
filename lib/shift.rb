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

  if sentry_dsn = ENV["SENTRY_DSN"]
    Raven.configure do |config|
      config.dsn = sentry_dsn
      config.environments = %w[ production ]
    end
  end
  
end
