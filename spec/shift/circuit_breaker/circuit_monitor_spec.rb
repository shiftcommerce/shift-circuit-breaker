require "spec_helper"

module Shift
  module CircuitBreaker
    describe CircuitMonitor do

      context "Recording metrics" do
        it "logs the metric information" do
          # Arrange
          logger_instance = ::Logger.new(STDOUT)
          monitor = described_class.new(logger: logger_instance)
          circuit_breaker_name = :test_circuit_breaker
          circuit_breaker_state = :open
          metric = "Custom/#{circuit_breaker_name.to_s.classify}CircuitBreaker/#{circuit_breaker_state.to_s.classify}"

          # Act & Assert
          expect(logger_instance).to receive(:info).with(include(metric))
          monitor.record_metric(circuit_breaker_name, circuit_breaker_state)
        end
      end 

    end
  end
end