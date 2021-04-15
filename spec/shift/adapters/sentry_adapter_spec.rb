# frozen_string_literal: true

require "spec_helper"

module Sentry
  def self.capture_exception(*)
  end
end

module Shift
  module CircuitBreaker
    module Adapters
      describe SentryAdapter do
        it "is a subclass of 'Shift::CircuitBreaker::Adapters::BaseAdapter'" do
          expect(described_class).to be < Shift::CircuitBreaker::Adapters::BaseAdapter
        end

        context "#call" do
          it "does not raise NotImplementedError" do
            # Arrange
            message = "some message"

            # Act & Assert
            expect { described_class.call(message) }.not_to raise_error(NotImplementedError)
          end

          it "calls Sentry#capture_exception" do
            # Arrange
            message = "some exception"

            allow(::Raven).to receive(:capture_exception)

            # Act
            described_class.call(message)

            # Assert
            expect(::Raven).to have_received(:capture_exception).with(message).once
          end
        end
      end
    end
  end
end
