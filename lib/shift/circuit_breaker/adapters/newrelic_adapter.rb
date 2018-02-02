module Shift
  module CircuitBreaker
    module Adapters
      class NewRelicAdapter < Base

        def self.call(message)
          ::NewRelic::Agent.increment_metric(message) if defined?(::NewRelic::Agent)
        end

      end 
    end 
  end 
end