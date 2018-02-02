module Shift
  module CircuitBreaker
    #
    # Global Configuration Object
    #
    # ==== Example Usage:
    # 
    # Add an initializer in your application (eg. shift_circuit_breaker.rb)
    # with the following configs:
    #
    # Shift::CircuitBreaker.configure do |config|
    #   config.new_relic_license_key  = ENV["NEW_RELIC_LICENSE_KEY"]
    #   config.new_relic_app_name     = ENV["NEW_RELIC_APP_NAME"]
    #   config.sentry_dsn             = ENV["SENTRY_DSN"]
    # end
    #
    class Config

      include Singleton

      attr_accessor :new_relic_license_key, :new_relic_app_name, :sentry_dsn

    end
  end
end