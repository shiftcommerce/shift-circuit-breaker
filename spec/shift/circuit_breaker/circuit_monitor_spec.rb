require "spec_helper"

module Shift
  module CircuitBreaker
    describe CircuitMonitor do

      context "#record_metric" do
        it "logs the metric information" do
          # Arrange
          circuit_breaker_name  = :test_circuit_breaker
          circuit_breaker_state = :open
          logger_instance       = ::Logger.new(STDOUT)
          monitor               = described_class.new(logger: logger_instance)
          metric                = "Custom/#{circuit_breaker_name.to_s.classify}CircuitBreaker/#{circuit_breaker_state.to_s.classify}"

          allow(logger_instance).to receive(:info)

          # Act 
          monitor.record_metric(circuit_breaker_name, circuit_breaker_state)

          # Assert
          expect(logger_instance).to have_received(:info).with(include(metric))
        end

        it "logs the metric information using the provided monitor" do
          # Arrange
          circuit_breaker_name  = :test_circuit_breaker
          circuit_breaker_state = :open
          metric_monitor        = Shift::CircuitBreaker::Adapters::NewRelicAdapter
          monitor               = described_class.new(monitor: metric_monitor)
          metric                = "Custom/#{circuit_breaker_name.to_s.classify}CircuitBreaker/#{circuit_breaker_state.to_s.classify}"

          allow(metric_monitor).to receive(:call)

          # Act 
          monitor.record_metric(circuit_breaker_name, circuit_breaker_state)

          # Assert
          expect(metric_monitor).to have_received(:call).with(metric)
        end
      end 

    end
  end
end