module Shift
  module CircuitBreaker
    module Adapters
      class BaseAdapter

        def self.call(message)
          raise NotImplementedError
        end

      end 
    end 
  end 
end
