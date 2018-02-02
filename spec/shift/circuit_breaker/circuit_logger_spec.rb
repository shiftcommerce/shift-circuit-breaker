require "spec_helper"

module Shift
  module CircuitBreaker
    describe CircuitLogger do

      context "Logging errors" do

        it "logs the given input" do
          # Arrange
          logger_instance = ::Logger.new(STDOUT)
          logger = described_class.new(logger: logger_instance)
          exception = Timeout::Error.new
          context  = { circuit_name: :test_circuit_breaker, error_message: exception.message, state: :open }
          error_message = (described_class::ERROR_MESSAGE % context)

          # Act & Assert
          expect(logger_instance).to receive(:error).with(include(error_message))
          logger.error(context)
        end
        
      end 

      context "Logging info" do

        it "logs the given input" do
          # Arrange
          logger_instance = ::Logger.new(STDOUT)
          logger = described_class.new(logger: logger_instance)
          message = "some information to log"

          # Act & Assert
          expect(logger_instance).to receive(:info).with(include(message))
          logger.info(message)
        end
        
      end 

    end
  end
end