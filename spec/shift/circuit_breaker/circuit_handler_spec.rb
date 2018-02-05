# frozen_string_literal: true

require "spec_helper"

module Shift
  module CircuitBreaker
    describe CircuitHandler do
      context "when given a valid operation" do
        let(:default_error_threshold) { 10 }
        let(:default_skip_duration)   { 60 }

        it "returns the expected result" do
          # Arrange
          operation_stub        = instance_double("Operation")
          fallback_stub         = instance_double("Fallback")
          expected_result_stub  = instance_double("ExpectedResult")

          allow(operation_stub).to receive(:perform_task).and_return(expected_result_stub)

          # Act
          cb = described_class.new(:test_circuit_breaker, error_threshold: default_error_threshold, skip_duration: default_skip_duration)
          operation_result = cb.call(operation: -> { operation_stub.perform_task }, fallback: -> { fallback_stub })

          # Assert
          expect(operation_result).to eq(expected_result_stub)
        end
      end

      context "when given additional exception classes" do
        let(:default_error_threshold) { 10 }
        let(:default_skip_duration)   { 60 }

        it "rescues the exception and returns the fallback" do
          # Arrange
          operation_stub                = instance_double("Operation")
          fallback_stub                 = instance_double("Fallback")
          additional_exception_classes  = [Faraday::ClientError]

          allow(operation_stub).to receive(:perform_task).and_raise(Faraday::ClientError, "client error")

          # Act
          cb = described_class.new(:test_circuit_breaker,
                                   error_threshold: default_error_threshold,
                                   skip_duration: default_skip_duration,
                                   additional_exception_classes: additional_exception_classes)

          operation_result = cb.call(operation: -> { operation_stub.perform_task }, fallback: -> { fallback_stub })

          # Assert
          expect(operation_result).to eq(fallback_stub)
        end
      end

      context "Invalid Arguments" do
        context "when initialising service" do
          let(:default_error_threshold) { 10 }
          let(:default_skip_duration)   { 60 }

          context "when no error_threshold is provided" do
            it "raises an ArgumentError" do
              # Act & Assert
              expect { described_class.new(:test_circuit_breaker, skip_duration: default_skip_duration) }.to raise_error(ArgumentError)
            end
          end

          context "when no skip_duration is provided" do
            it "raises an ArgumentError" do
              # Act & Assert
              expect { described_class.new(:test_circuit_breaker, error_threshold: default_skip_duration) }.to raise_error(ArgumentError)
            end
          end
        end

        context "Invalid #call arguments" do
          let(:default_error_threshold) { 10 }
          let(:default_skip_duration)   { 60 }

          context "when no operation is given" do
            it "raises an ArgumentError" do
              # Arrange
              fallback_stub = instance_double("Fallback")

              # Act
              cb = described_class.new(:test_circuit_breaker, error_threshold: default_error_threshold, skip_duration: default_skip_duration)

              # Assert
              expect { cb.call(fallback: -> { fallback_stub }) }.to raise_error(ArgumentError)
            end
          end

          context "when no fallback is given" do
            it "raises an ArgumentError" do
              # Arrange
              operation_stub = instance_double("Operation")

              # Act
              cb = described_class.new(:test_circuit_breaker, error_threshold: default_error_threshold, skip_duration: default_skip_duration)

              # Act & Assert
              expect { cb.call(operation: -> { operation_stub }) }.to raise_error(ArgumentError)
            end
          end

          context "when given nil as the operation" do
            it "raises an ArgumentError" do
              # Arrange
              fallback_stub = instance_double("Fallback")

              # Act
              cb = described_class.new(:test_circuit_breaker, error_threshold: default_error_threshold, skip_duration: default_skip_duration)

              # Assert
              expect { cb.call(operation: nil, fallback: -> { fallback_stub }) }.to raise_error(ArgumentError)
            end
          end

          context "when given nil as the fallback" do
            it "raises an ArgumentError" do
              # Arrange
              operation_stub = instance_double("Operation")

              # Act
              cb = described_class.new(:test_circuit_breaker, error_threshold: default_error_threshold, skip_duration: default_skip_duration)

              # Assert
              expect { cb.call(operation: -> { operation_stub }, fallback: nil) }.to raise_error(ArgumentError)
            end
          end

          context "when given an operation that does not implement #call" do
            it "raises an ArgumentError" do
              # Arrange
              operation_stub  = instance_double("Operation")
              fallback_stub   = instance_double("Fallback")

              # Act
              cb = described_class.new(:test_circuit_breaker, error_threshold: default_error_threshold, skip_duration: default_skip_duration)

              # Assert
              expect { cb.call(operation: operation_stub, fallback: -> { fallback_stub }) }.to raise_error(ArgumentError)
            end
          end

          context "when given a fallback that does not implement #call" do
            it "raises an ArgumentError" do
              # Arrange
              operation_stub  = instance_double("Operation")
              fallback_stub   = instance_double("Fallback")

              # Act
              cb = described_class.new(:test_circuit_breaker, error_threshold: default_error_threshold, skip_duration: default_skip_duration)

              # Assert
              expect { cb.call(operation: -> { operation_stub }, fallback: fallback_stub) }.to raise_error(ArgumentError)
            end
          end
        end
      end
    end
  end
end
