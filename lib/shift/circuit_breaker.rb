require "active_support/core_ext/module/delegation"
require "active_support/core_ext/string/inflections"
require "faraday"
require "logger"
require "newrelic_rpm"
require "sentry-raven"
require "timeout"

require "shift/circuit_breaker/config"
require "shift/circuit_breaker/circuit_logger"
require "shift/circuit_breaker/circuit_monitor"
require "shift/circuit_breaker/circuit_handler"
require "shift/circuit_breaker/version"


module Shift
  module CircuitBreaker

    class << self

      def new(*args)
        Shift::CircuitBreaker::CircuitHandler.new(*args)
      end

      def config
        @config ||= Shift::CircuitBreaker::Config.instance
      end

      def configure
        Shift::CircuitBreaker::Config.instance.tap do |config| 
          yield config if block_given?
        end
      end

    end

  end
end

if sentry_dsn = Shift::CircuitBreaker.config.sentry_dsn
  Raven.configure do |config|
    config.dsn = sentry_dsn
    config.environments = %w[ production ]
  end
end