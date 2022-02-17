# frozen_string_literal: true

module Shift
  module CircuitBreaker
    module Adapters
      class SentryAdapter < BaseAdapter
        def self.call(message)
          ::Sentry.capture_exception(message) if defined?(Sentry)
        end
      end
    end
  end
end
