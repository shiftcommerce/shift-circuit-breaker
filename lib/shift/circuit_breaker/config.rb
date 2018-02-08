# frozen_string_literal: true

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
    #   config.sentry_environments    = %w[ production ]
    # end
    #
    class Config
      include Singleton

      attr_accessor :new_relic_license_key, :new_relic_app_name, :sentry_dsn, :sentry_environments

      def initialize_dependencies
        initialize_sentry
        initialize_newrelic
      end

      private

      def initialize_sentry
        if sentry_dsn
          Raven.configure do |config|
            config.dsn = sentry_dsn
            config.environments = sentry_environments if sentry_environments.present?
          end
        end
      end

      def initialize_newrelic
        if new_relic_app_name.present? && new_relic_license_key.present?
          require "newrelic_rpm"
        end
      end
    end
  end
end
