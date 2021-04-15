# frozen_string_literal: true

require "spec_helper"

module NewRelic
  module Agent
    def self.increment_metric(*)
    end
  end
end

module Shift
  module CircuitBreaker
    module Adapters
      describe NewRelicAdapter do
        it "is a subclass of 'Shift::CircuitBreaker::Adapters::BaseAdapter'" do
          expect(described_class).to be < Shift::CircuitBreaker::Adapters::BaseAdapter
        end

        context "#call" do
          it "does not raise NotImplementedError" do
            # Arrange
            metric = "Custom/TestCircuitBreaker/closed"

            # Act & Assert
            expect { described_class.call(metric) }.not_to raise_error(NotImplementedError)
          end

          it "calls NewRelic::Agent#increment_metric" do
            # Arrange
            metric = "Custom/TestCircuitBreaker/closed"

            allow(::NewRelic::Agent).to receive(:increment_metric)

            # Act
            described_class.call(metric)

            # Assert
            expect(::NewRelic::Agent).to have_received(:increment_metric).with(metric).once
          end
        end
      end
    end
  end
end
