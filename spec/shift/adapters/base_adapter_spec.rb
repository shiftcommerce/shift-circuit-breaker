# frozen_string_literal: true

require "spec_helper"

module Shift
  module CircuitBreaker
    module Adapters
      describe BaseAdapter do
        context "#call" do
          it "raises NotImplementedError" do
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
