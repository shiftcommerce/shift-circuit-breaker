module Shift
  module ::CircuitBreaker
    class CircuitLogger

      attr_accessor :logger, :external_error_logger

      delegate :debug, :fatal, :info, :warn, :add, :log, to: :logger

      ERROR_MESSAGE = <<~EOF
        ====================================================================================
        CIRCUIT BREAKER REQUEST FAILURE: %{circuit_name}

        STATE: %{state}
        MESSAGE: %{error_message}
        ====================================================================================
        EOF

      # Initializer creates an instance of the service
      #
      # @param [Object]  logger  - service to handle internal logging
      # @param [Object]  external_error_logger - external error logging service eg. Sentry
      def initialize(logger: ::Logger.new(STDOUT), external_error_logger: lambda { |error| ::Raven.capture_exception(error) })
        self.logger = logger
        self.external_error_logger = external_error_logger
      end

      # @param [Object] context - contains :circuit_name, :state, :error_message
      def error(context)
        message = (ERROR_MESSAGE % context)
        logger.error(message)
        external_error_logger.call(message) if external_error_logger.respond_to?(:call)
      end 

    end
  end
end