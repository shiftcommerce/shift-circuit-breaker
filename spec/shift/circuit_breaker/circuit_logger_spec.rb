# frozen_string_literal: true

require "spec_helper"

module Shift
  module CircuitBreaker
    describe CircuitLogger do
      before do
        allow($stdout).to receive(:write)
      end

      context "#error" do
        it "logs the given error message" do
          # Arrange
          context         = { circuit_name: :test_circuit_breaker, error_message: "timeout", state: :open }
          error_message   = (described_class::ERROR_MESSAGE % context)
          logger_instance = ::Logger.new(STDOUT)
          logger          = described_class.new(logger: logger_instance)

          allow(logger_instance).to receive(:error)

          # Act
          logger.error(context)

          # Assert
          expect(logger_instance).to have_received(:error).with(include(error_message))
        end

        it "logs the given error message using the provided external_error_logger" do
          # Arrange
          context               = { circuit_name: :test_circuit_breaker, error_message: "timeout", state: :open }
          error_message         = (described_class::ERROR_MESSAGE % context)
          external_error_logger = Shift::CircuitBreaker::Adapters::SentryAdapter
          logger                = described_class.new(external_error_logger: external_error_logger)

          allow(external_error_logger).to receive(:call)

          # Act
          logger.error(context)

          # Assert
          aggregate_failures do
            expect(logger.external_error_logger).to eq(external_error_logger)
            expect(external_error_logger).to have_received(:call).with(include(error_message))
          end
        end
      end

      context "#info" do
        it "logs the given input" do
          # Arrange
          message         = "some message"
          logger_instance = ::Logger.new(STDOUT)
          logger          = described_class.new(logger: logger_instance)

          allow(logger_instance).to receive(:info)

          # Act
          logger.info(message)

          # Assert
          expect(logger_instance).to have_received(:info).with(include(message))
        end
      end
    end
  end
end
