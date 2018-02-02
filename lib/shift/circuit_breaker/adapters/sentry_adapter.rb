module Shift
  module CircuitBreaker
    module Adapters
      class SentryAdapter < Base

        def self.call(message)
          ::Raven.capture_exception(message) if defined?(Raven)
        end

      end 
    end 
  end 
end