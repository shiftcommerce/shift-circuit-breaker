# frozen_string_literal: true

module Shift
  module CircuitBreaker
    module Adapters
      class BaseAdapter
        def self.call(_message)
          raise NotImplementedError
        end
      end
    end
  end
end
