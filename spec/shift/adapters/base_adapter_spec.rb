require "spec_helper"

module Shift
  module CircuitBreaker
    module Adapters
      describe BaseAdapter do

        context "#call" do
          it 'does raises NotImplementedError' do
            # Arrange
            message = "some message"

            # Act & Assert
            expect { described_class.call(message) }.to raise_error(NotImplementedError)
          end
        end

      end
    end
  end
end
