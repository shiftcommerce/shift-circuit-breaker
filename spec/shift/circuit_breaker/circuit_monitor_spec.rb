# frozen_string_literal: true

require "spec_helper"

module Shift
  module CircuitBreaker
    describe CircuitMonitor do
      before do
        allow($stdout).to receive(:write)
      end

      context "#record_metric" do
        it "logs the metric information" do
          # Arrange
          circuit_breaker_name  = :test_circuit_breaker
          circuit_breaker_state = :open
          metric                = "Custom/#{circuit_breaker_name.to_s.classify}CircuitBreaker/#{circuit_breaker_state.to_s.classify}"
          logger_instance       = ::Logger.new(STDOUT)
          circuit_monitor       = described_class.new(logger: logger_instance)

          allow(logger_instance).to receive(:info)

          # Act
          circuit_monitor.record_metric(circuit_breaker_name, circuit_breaker_state)

          # Assert
          expect(logger_instance).to have_received(:info).with(include(metric))
        end

        it "logs the metric information using the provided monitor" do
          # Arrange
          circuit_breaker_name  = :test_circuit_breaker
          circuit_breaker_state = :open
          metric                = "Custom/#{circuit_breaker_name.to_s.classify}CircuitBreaker/#{circuit_breaker_state.to_s.classify}"
          metric_monitor        = Shift::CircuitBreaker::Adapters::NewRelicAdapter
          circuit_monitor       = described_class.new(monitor: metric_monitor)

          allow(metric_monitor).to receive(:call)

          # Act
          circuit_monitor.record_metric(circuit_breaker_name, circuit_breaker_state)

          # Assert
          aggregate_failures do
            expect(circuit_monitor.monitor).to eq(metric_monitor)
            expect(metric_monitor).to have_received(:call).with(metric)
          end
        end
      end
    end
  end
end
