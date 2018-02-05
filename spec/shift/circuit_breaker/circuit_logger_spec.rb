require "spec_helper"

module Shift
  module CircuitBreaker
    describe CircuitLogger do

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