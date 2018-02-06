# frozen_string_literal: true

module Shift
  module CircuitBreaker
    module Adapters
      class NewRelicAdapter < BaseAdapter
        def self.call(message)
          ::NewRelic::Agent.increment_metric(message) if defined?(NewRelic)
        end
      end
    end
  end
end
