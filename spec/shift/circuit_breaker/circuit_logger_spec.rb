# frozen_string_literal: true

require "spec_helper"

module NewRelic
  module Agent
    def self.notice_error(*); end
  end
end

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

        it "logs the given error message using the provided remote_logger" do
          # Arrange
          context       = { circuit_name: :test_circuit_breaker, error_message: "timeout", state: :open, remote_logging_enabled: true }
          error_message = (described_class::ERROR_MESSAGE % context)
          remote_logger = Shift::CircuitBreaker::Adapters::SentryAdapter
          logger        = described_class.new(remote_logger: remote_logger)

          allow(remote_logger).to receive(:call)
          allow(::NewRelic::Agent).to receive(:notice_error)

          # Act
          logger.error(context)

          # Assert
          aggregate_failures do
            expect(logger.remote_logger).to eq(remote_logger)
            expect(remote_logger).to have_received(:call).with(include(error_message))
          end
        end

        it "should not log error to remote_error if remote_logging_enabled is set to false" do
          # Arrange
          context       = { circuit_name: :test_circuit_breaker, error_message: "timeout", state: :open, remote_logging_enabled: false }
          error_message = (described_class::ERROR_MESSAGE % context)
          remote_logger = Shift::CircuitBreaker::Adapters::SentryAdapter
          logger        = described_class.new(remote_logger: remote_logger)

          allow(remote_logger).to receive(:call)
          allow(::NewRelic::Agent).to receive(:notice_error)

          # Act
          logger.error(context)

          # Assert
          aggregate_failures do
            expect(logger.remote_logger).to eq(remote_logger)
            expect(remote_logger).not_to have_received(:call).with(include(error_message))
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
