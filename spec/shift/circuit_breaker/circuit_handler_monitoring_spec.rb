# frozen_string_literal: true

require "spec_helper"

module Shift
  module CircuitBreaker
    describe CircuitHandler do
      before do
        allow($stdout).to receive(:write)
      end

      context "Monitoring" do
        let(:default_error_threshold) { 10 }
        let(:default_skip_duration)   { 60 }

        context "when an operation is successful" do
          it "records the metric" do
            # Arrange
            monitor_stub          = instance_double("Shift::CircuitMonitor")
            operation_stub        = instance_double("Operation")
            fallback_stub         = instance_double("Fallback")
            expected_result_stub  = instance_double("ExpectedResult")

            allow(monitor_stub).to receive(:record_metric)
            allow(operation_stub).to receive(:perform_task).and_return(expected_result_stub)

            # Act
            cb = described_class.new(:test_circuit_breaker,
                                     error_threshold: default_skip_duration,
                                     skip_duration: default_skip_duration,
                                     monitor: monitor_stub)

            # Assert
            aggregate_failures do
              expect(operation_stub).to receive(:perform_task).and_return(expected_result_stub)

              operation_result = cb.call(operation: -> { operation_stub.perform_task }, fallback: -> { fallback_stub })

              expect(monitor_stub).to have_received(:record_metric)
              expect(operation_result).to eq(expected_result_stub)
            end
          end
        end

        context "when an exception is raised" do
          it "records the metric" do
            # Arrange
            monitor_stub    = instance_double("Shift::CircuitMonitor")
            operation_stub  = instance_double("Operation")
            fallback_stub   = instance_double("Fallback")

            allow(monitor_stub).to receive(:record_metric)
            allow(operation_stub).to receive(:perform_task).and_raise(Timeout::Error, "Request Timeout")

            # Act
            cb = described_class.new(:test_circuit_breaker, error_threshold: 1, skip_duration: default_skip_duration, monitor: monitor_stub)

            # Assert
            aggregate_failures do
              expect(operation_stub).to receive(:perform_task).and_raise(Timeout::Error, "Request Timeout")

              operation_result = cb.call(operation: -> { operation_stub.perform_task }, fallback: -> { fallback_stub })

              expect(monitor_stub).to have_received(:record_metric)
              expect(operation_result).to eq(fallback_stub)
            end
          end
        end
      end
    end
  end
end
