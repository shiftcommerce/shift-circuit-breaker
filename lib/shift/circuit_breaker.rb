require "active_support/core_ext/module/delegation"
require "active_support/core_ext/string/inflections"
require "faraday"
require "logger"
require "newrelic_rpm"
require "sentry-raven"
require "singleton"
require "timeout"

require "shift/circuit_breaker/adapters/base"
require "shift/circuit_breaker/adapters/sentry"
require "shift/circuit_breaker/adapters/newrelic"
require "shift/circuit_breaker/config"
require "shift/circuit_breaker/circuit_logger"
require "shift/circuit_breaker/circuit_monitor"
require "shift/circuit_breaker/circuit_handler"
require "shift/circuit_breaker/version"

module Shift
  #
  # ==== Example Usage:
  #
  # class MyClass
  #   CIRCUIT_BREAKER = Shift::CircuitBreaker.new(:an_identifier_for_the_circuit, 
  #                                               error_threshold: 10, 
  #                                               skip_duration: 60, 
  #                                               additional_exception_classes: [ Excon::Errors::SocketError ]
  #                                             )
  #
  #   def do_something
  #     # Note: operation and fallback should implement the public method #call or wrapped in a Proc/Lambda (as in the example below).
  #     CIRCUIT_BREAKER.call(operation: -> { SomeService.new(name: 'test').perform_task }, fallback: -> { [ 1, 2, 3, 4, 5 ].sum })
  #   end
  # end
  #
  module CircuitBreaker

    class << self

      def new(*args)
        Shift::CircuitBreaker::CircuitHandler.new(*args)
      end

      def config
        @config ||= Shift::CircuitBreaker::Config.instance
      end

      def configure
        @config = Shift::CircuitBreaker::Config.instance.tap do |config| 
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