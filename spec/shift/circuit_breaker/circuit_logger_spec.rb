require "spec_helper"

module Shift
  module CircuitBreaker
    describe CircuitLogger do

      context "#error" do
        it "logs the given error message" do
          # Arrange
          logger_instance = ::Logger.new(STDOUT)
          logger = described_class.new(logger: logger_instance)
          exception = Timeout::Error.new
          context  = { circuit_name: :test_circuit_breaker, error_message: exception.message, state: :open }
          error_message = (described_class::ERROR_MESSAGE % context)

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
          logger_instance = ::Logger.new(STDOUT)
          logger = described_class.new(logger: logger_instance)
          message = "some information to log"

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