# frozen_string_literal: true

module Shift
  module CircuitBreaker
    class CircuitLogger
      attr_accessor :logger, :external_error_logger

      delegate :debug, :fatal, :info, :warn, :add, :log, to: :logger

      ERROR_MESSAGE = <<~EOF
        ====================================================================================
        CIRCUIT BREAKER REQUEST FAILURE: %<circuit_name>s

        STATE: %<state>s
        MESSAGE: %<error_message>s
        ====================================================================================
        EOF

      # Initializer creates an instance of the service
      #
      # @param [Object]  logger  - service to handle internal logging
      # @param [Object]  external_error_logger - external error logging service eg. Sentry
      def initialize(logger: ::Logger.new(STDOUT), external_error_logger: Shift::CircuitBreaker::Adapters::SentryAdapter)
        self.logger = logger
        self.external_error_logger = external_error_logger
      end

      # @param [Object] context - contains :circuit_name, :state, :error_message
      def error(context)
        message = (ERROR_MESSAGE % context)
        binding.pry
        logger.error(message)
        external_error_logger.call(message) if external_error_logger.respond_to?(:call)
      end
    end
  end
end
