require "spec_helper"

module Shift
  describe CircuitBreaker do

    context "Configuration" do 
      it "correctly assigns the keys" do
        # Arrange
        dummy_new_relic_license_key = SecureRandom.hex(10)
        dummy_new_relic_app_name    = "Test App"
        dummy_sentry_dsn            = SecureRandom.hex(10)
        dummy_sentry_environments   = %w[ production ]

        # Act
        Shift::CircuitBreaker.configure do |config|
          config.new_relic_license_key  = dummy_new_relic_license_key
          config.new_relic_app_name     = dummy_new_relic_app_name
          config.sentry_dsn             = dummy_sentry_dsn
          config.sentry_environments    = dummy_sentry_environments
        end

        config = Shift::CircuitBreaker.config

        # Assert
        aggregate_failures do 
          expect(config.new_relic_license_key).to eq(dummy_new_relic_license_key)
          expect(config.new_relic_app_name).to eq(dummy_new_relic_app_name)
          expect(config.sentry_dsn).to eq(dummy_sentry_dsn)
          expect(config.sentry_environments).to include("production")
        end
      end
    end

    context "Instantiation" do 
      it "creates an instance of the service" do
        # Arrange

        # Act

        # Assert

      end
    end

  end
end
