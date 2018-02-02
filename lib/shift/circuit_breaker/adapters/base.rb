module Shift
  module CircuitBreaker
    module Adapters
      class Base

        def self.call(message)
          raise NotImplementedError
        end

      end 
    end 
  end 
end