require "spec_helper"

module Shift
  module CircuitBreaker
    module Adapters
      describe NewRelicAdapter do

        context "#call" do
          it 'does not raise NotImplementedError' do
            # Arrange
            message = "some message"

            # Act & Assert
            expect { described_class.call(message) }.not_to raise_error(NotImplementedError)
          end
        end

      end
    end
  end
end