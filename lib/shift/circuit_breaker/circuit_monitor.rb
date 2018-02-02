module Shift
  module CircuitBreaker
    class CircuitMonitor

      attr_accessor :monitor, :logger

      # Initializer creates an instance of the service
      #
      # @param [Object] monitor - service to handle monitoring
      # @param [Object] logger  - service to handle logging
      def initialize(monitor: lambda { |metric| ::NewRelic::Agent.increment_metric(metric) }, logger: Shift::CircuitBreaker::CircuitLogger.new)
        self.monitor = monitor
        self.logger = logger
      end

      # @param [String] name - The circuit name 
      # @param [Symbol] state - The circuit state
      def record_metric(name, state)
        metric = formatted_metric(name, state)
        monitor.call(metric) if monitor.respond_to?(:call)
        logger.info("* #{metric} *")
      end

      private 

      def formatted_metric(name, state)
        "Custom/#{name.to_s.classify}CircuitBreaker/#{state.to_s.classify}"
      end

    end
  end
end
