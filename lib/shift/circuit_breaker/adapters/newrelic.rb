module Shift
  module CircuitBreaker
    module Adapters
      class NewRelic < Base

        def self.call(message)
          if Shift::CircuitBreaker.config.new_relic_app_name && Shift::CircuitBreaker.config.new_relic_license_key
            ::NewRelic::Agent.increment_metric(message)
          end
        end

      end 
    end 
  end 
end