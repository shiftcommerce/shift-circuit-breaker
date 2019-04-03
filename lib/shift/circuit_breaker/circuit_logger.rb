# frozen_string_literal: true

module Shift
  module CircuitBreaker
    class CircuitLogger
      attr_accessor :logger, :remote_logger

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
      # @param [Object]  remote_logger - external error logging service eg. Sentry
      def initialize(logger: ::Logger.new(STDOUT), remote_logger: Shift::CircuitBreaker::Adapters::SentryAdapter)
        self.logger = logger
        self.remote_logger = remote_logger
      end

      # @param [Object] context - contains :circuit_name, :state, :error_message
      def error(context)
        message = (ERROR_MESSAGE % context)
        logger.error(message)
        ::NewRelic::Agent.notice_error(context[:exception], expected: true) if defined?(NewRelic)
        remote_logger.call(message) if context[:remote_logging_enabled] && remote_logger.respond_to?(:call)
      end
    end
  end
end
