require "spec_helper"

describe Shift::CircuitMonitor do

  context "Recording metrics" do

    it "logs the metric information" do
      # Arrange
      default_logger = ::Logger.new(STDOUT)
      monitor = described_class.new(logger: default_logger)
      circuit_breaker_name = :test_circuit_breaker
      circuit_breaker_state = :open
      metric = "Custom/#{circuit_breaker_name.to_s.classify}CircuitBreaker/#{circuit_breaker_state.to_s.classify}"

      # Act & Assert
      expect(default_logger).to receive(:info).with(include(metric))
      monitor.record_metric(circuit_breaker_name, circuit_breaker_state)
    end
    
  end 

end