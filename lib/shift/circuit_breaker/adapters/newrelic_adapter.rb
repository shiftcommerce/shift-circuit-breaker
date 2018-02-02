module Shift
  module CircuitBreaker
    module Adapters
      class NewRelicAdapter < BaseAdapter

        def self.call(message)
          ::NewRelic::Agent.increment_metric(message) if defined?(::NewRelic::Agent)
        end

      end 
    end 
  end 
end