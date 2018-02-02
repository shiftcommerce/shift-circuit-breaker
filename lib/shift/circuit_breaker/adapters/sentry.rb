module Shift
  module CircuitBreaker
    module Adapters
      class Sentry < Base

        def self.call(message)
          ::Raven.capture_exception(message) if defined?(Raven)
        end

      end 
    end 
  end 
end