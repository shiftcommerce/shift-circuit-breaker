# frozen_string_literal: true

module Shift
  module CircuitBreaker
    #
    # === Overview
    #
    # Implements a generic mechanism for detecting external service call timeouts and reduces the
    # time spent waiting for further requests that will most-likely fail (e.g. timeout) and cause request queueing.
    #
    # Similar to a conventional circuit breaker, when a circuit is closed it allows operations
    # to flow through. When the error_threshold is exceeded (tripped), the circuit is then opened for
    # the defined skip_duration, ie. no operations are executed and the provided fallback is called.
    #
    class CircuitHandler
      attr_accessor :name, :error_threshold, :skip_duration, :exception_classes, :error_logging_enabled, :error_count
      attr_accessor :last_error_time, :state, :logger, :monitor

      DEFAULT_EXCEPTION_CLASSES = [Net::OpenTimeout, Net::ReadTimeout, Faraday::TimeoutError, Timeout::Error].freeze
      DEFAULT_ERROR_LOGGING_STATE = true

      # Initializer creates an instance of the service
      #
      # @param [Symbol]  name              - the name used to identify the circuit breaker
      # @param [Integer] error_threshold   - The minimum error threshold required for the circuit to be opened/tripped
      # @param [Integer] skip_duration     - The duration in seconds the circuit should be open for before operations are allowed through/executed
      # @param [Array]   additional_exception_classes - Any additional exception classes to rescue along the DEFAULT_EXCEPTION_CLASSES
      # @param [Boolean] error_logging_enabled         - Decided whether to log errors or not. Still they will be monitored
      # @param [Object]  logger            - service to handle error logging
      # @param [Object]  monitor           - service to monitor metric
      def initialize(name:,
        error_threshold:,
        skip_duration:,
        additional_exception_classes: [],
        error_logging_enabled: DEFAULT_ERROR_LOGGING_STATE,
        logger: Shift::CircuitBreaker::CircuitLogger.new,
        monitor: Shift::CircuitBreaker::CircuitMonitor.new)

        self.name = name
        self.error_threshold = error_threshold
        self.skip_duration = skip_duration
        self.error_logging_enabled = error_logging_enabled
        self.exception_classes = (additional_exception_classes | DEFAULT_EXCEPTION_CLASSES)
        self.logger = logger
        self.monitor = monitor
        self.error_count = 0
        self.last_error_time = nil
        self.state = :closed
      end

      # Performs the given operation within the circuit
      # @param [Proc] operation - the operation to be performed
      # @param [Proc] fallback  - The result returned if the operation is not performed or raises an exception
      def call(operation:, fallback:)
        raise ArgumentError unless operation.respond_to?(:call) && fallback.respond_to?(:call)
        set_state
        if state == :open
          monitor.record_metric(name, state)
          return fallback.call
        end
        perform_operation(operation, fallback)
      end

      private

      def set_state
        # The circuit is opened/tripped if the error_threshold is met or exceeded
        # (error_count >= error_threshold) and the last_error_time is within
        # the skip_duration (see comments in #skip_duration_expired?).
        self.state = \
          if (error_count >= error_threshold) && !skip_duration_expired?
            :open
          else
            :closed
          end
      end

      def skip_duration_expired?
        return true unless last_error_time.present?
        # IF the difference in time between now and the last_error_time
        # is greater than the skip_duration, then it will have expired.
        (Time.now - last_error_time) > skip_duration
      end

      def reset_state
        # Reset the error attributes to default values.
        self.error_count = 0
        self.last_error_time = nil
        self.state = :closed
      end

      def record_error
        # Increment the error_count
        self.error_count += 1
        # Set the time the error occured.
        self.last_error_time = Time.now
      end

      def perform_operation(operation, fallback)
        response = operation.call
        reset_state
        monitor.record_metric(name, state)
        response
      rescue *exception_classes
        handle_exception($!, fallback)
      end

      def handle_exception(exception, fallback)
        record_error
        set_state
        log_errors(exception)
        # Increments exceptions; useful for alerting
        monitor.record_exception(name, "errored")
        fallback.call
      end

      def log_errors(exception)
        logger.error(
          circuit_name: name,
          state: state,
          exception: exception,
          error_message: exception.message,
          remote_logging_enabled: error_logging_enabled
        )
      end
    end
  end
end
