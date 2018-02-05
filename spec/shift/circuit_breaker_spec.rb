require "spec_helper"

module Shift
  describe CircuitBreaker do

    context "Configuration" do 
      it "correctly assigns the configuration keys" do
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
      it "creates an instance of the circuit breaker" do
        # Arrange
        cb_name                       = :test_circuit
        error_threshold               = 10
        skip_duration                 = 60
        additional_exception_classes  = [ Faraday::ClientError ]
        logger_stub                   = instance_double("CustomLogger")
        monitor_stub                  = instance_double("CustomMonitor")

        # Act
        cb_instance = Shift::CircuitBreaker.new(cb_name, 
                                                error_threshold: error_threshold, 
                                                skip_duration: skip_duration, 
                                                additional_exception_classes: additional_exception_classes,
                                                logger: logger_stub,
                                                monitor: monitor_stub
                                              )

        # Assert
        aggregate_failures do
          expect(described_class).to be_a(Module)
          expect(cb_instance).to be_a(Shift::CircuitBreaker::CircuitHandler)
          expect(cb_instance.name).to eq(cb_name)
          expect(cb_instance.error_threshold).to eq(error_threshold)
          expect(cb_instance.skip_duration).to eq(skip_duration)
          expect(cb_instance.exception_classes).to include(Faraday::ClientError)
          expect(cb_instance.logger).to eq(logger_stub)
          expect(cb_instance.monitor).to eq(monitor_stub)
          expect(cb_instance.error_count).to eq(0)
          expect(cb_instance.state).to eq(:closed)
        end
      end
    end

  end
end
