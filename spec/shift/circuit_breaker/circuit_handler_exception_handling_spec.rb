require "spec_helper"

module Shift
  module CircuitBreaker
    describe CircuitHandler do

      context "Exception Handling" do
        let(:default_error_threshold) { 10 }
        let(:default_skip_duration)   { 60 }

        context "when a timeout exception is raised" do
          it "returns the fallback" do
            # Arrange
            operation_stub = instance_double("Operation")
            fallback_stub = instance_double("Fallback")

            allow(operation_stub).to receive(:perform_task).and_raise(Timeout::Error, "Request Timeout")

            # Act
            cb = described_class.new(:test_circuit_breaker, error_threshold: default_error_threshold, skip_duration: default_skip_duration)
            operation_result = cb.call(operation: -> { operation_stub.perform_task }, fallback: -> { fallback_stub })

            # Assert
            expect(operation_result).to eq(fallback_stub)
          end
        end

        context "when the error_threshold is exceeded" do
          it "opens the curcuit returns the fallback" do
            # Arrange
            operation_1_stub = instance_double('Operation1')
            operation_2_stub = instance_double('Operation2')
            operation_3_stub = instance_double('Operation3')
            
            fallback_stub = instance_double("Fallback")

            allow(operation_1_stub).to receive(:perform_task).and_raise(Timeout::Error, "Request Timeout")
            allow(operation_2_stub).to receive(:perform_task).and_raise(Timeout::Error, "Request Timeout")
            allow(operation_3_stub).to receive(:perform_task).and_raise(Timeout::Error, "Request Timeout")

            # Act & Assert
            cb = described_class.new(:test_circuit_breaker, error_threshold: 2, skip_duration: default_skip_duration)

            # First and second requests should increment the error_count and result in #call being executed
            # The operations will fail with Rack::Timeout::RequestTimeoutException, resulting in the exception
            # being raised and caught, and the fallback being returned as the operation result
            [ operation_1_stub, operation_2_stub ].each do |operation_stub|
              aggregate_failures do
                expect(operation_stub).to receive(:perform_task).and_raise(Timeout::Error, "Request Timeout")     
                result = cb.call(operation: -> { operation_stub.perform_task }, fallback: -> { fallback_stub })
                # Check Circuit Breaker state and result
                expect(cb.state).to eq(:closed)
                expect(result).to eq(fallback_stub)
              end
            end

            # Third request should exceed the error_threshold (set at 2) and open the circuit. This should result 
            # in #call not being executed and the fallback being returned early.
            aggregate_failures do
              expect(operation_3_stub).not_to receive(:perform_task)
              operation_3_result = cb.call(operation: -> { operation_3_stub.perform_task }, fallback: -> { fallback_stub })
               # Check Circuit Breaker state and result
              expect(cb.state).to eq(:open)
              expect(operation_3_result).to eq(fallback_stub)
            end
          end
        end

        context "when the error_threshold is exceeded and skip_duration has expired" do
          it "closes the circuit and returns the operation result" do
            # Arrange
            operation_1_stub = instance_double('Operation1')
            operation_2_stub = instance_double('Operation2')
            operation_3_stub = instance_double('Operation3')

            fallback_stub = instance_double("Fallback")
            expected_result_stub = instance_double("ExpectedResult")

            allow(operation_1_stub).to receive(:perform_task).and_raise(Timeout::Error, "Request Timeout")
            allow(operation_2_stub).to receive(:perform_task).and_raise(Timeout::Error, "Request Timeout")
            allow(operation_3_stub).to receive(:perform_task).and_return(expected_result_stub)

            # Act & Assert
            cb = described_class.new(:test_circuit_breaker, error_threshold: 1, skip_duration: 1)

            # The first request should increment the error_count and result in the operation being performed
            # The operation will fail with Rack::Timeout::RequestTimeoutException, resulting in the exception
            # being caught and the fallback being returned as the operation result
            aggregate_failures do
              operation_1_result = cb.call(operation: -> { operation_1_stub.perform_task }, fallback: -> { fallback_stub })
               # Check Circuit Breaker state and result
              expect(cb.state).to eq(:closed)
              expect(operation_1_result).to eq(fallback_stub)
            end

            # The second request should exceed the error threshold and open the circuit. This should result in 
            # the operation not being performed and the fallback being returned early.
            aggregate_failures do
              expect(operation_2_stub).not_to receive(:perform_task)
              operation_2_result = cb.call(operation: -> { operation_2_stub.perform_task }, fallback: -> { fallback_stub })
              # Check Circuit Breaker state and result
              expect(cb.state).to eq(:open)
              expect(operation_2_result).to eq(fallback_stub)
            end

            # The third request is fired after the skip duration has expired. It should the allowed to execute,
            # ie. #call should be executed, and the expected operation result returned.
            aggregate_failures do
              sleep(1)  # Buy time - 1 second
              operation_3_result = cb.call(operation: -> { operation_3_stub.perform_task }, fallback: -> { fallback_stub })

              # Check Circuit Breaker state and result
              expect(cb.state).to eq(:closed)
              expect(operation_3_result).to eq(expected_result_stub)
            end
          end
        end
      end

    end
  end
end
