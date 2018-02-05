# frozen_string_literal: true

module Shift
  module CircuitBreaker
    module Adapters
      class SentryAdapter < BaseAdapter
        def self.call(message)
          ::Raven.capture_exception(message) if defined?(Raven)
        end
      end
    end
  end
end
