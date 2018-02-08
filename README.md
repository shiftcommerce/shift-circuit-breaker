[ ![Codeship Status for shiftcommerce/shift-circuit-breaker](https://app.codeship.com/projects/76d6b9e0-ecaa-0135-f112-7a88d47e1dcf/status?branch=master)](https://app.codeship.com/projects/270371) [![Maintainability](https://api.codeclimate.com/v1/badges/7d52af723c1579961280/maintainability)](https://codeclimate.com/github/shiftcommerce/shift-circuit-breaker/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/7d52af723c1579961280/test_coverage)](https://codeclimate.com/github/shiftcommerce/shift-circuit-breaker/test_coverage)

# Shift Circuit Breaker

The Shift Circuit Breaker library implements a generic mechanism for detecting, monitoring and controlling external service calls that will most-likely fail at some point (e.g. timeout) and cause request queuing.

Although a plethora of Ruby circuit breaker libraries exist, those that are frequently updated have a dependency on Redis for persistence. We required a solution that did not depend on persisting to a shared data store, i.e. a library that stores counters in local memory. As a result, the Shift Circuit Breaker was born.

Similar to a conventional circuit breaker, when a circuit is closed it allows operations to flow through. When the number of sequential errors exceeds the `error_threshold`, the circuit is then opened for the defined `skip_duration` – no operations are executed and the provided `fallback` is called.

## Installation

Add this line to your application's Gemfile:

```
  $ gem "shift-circuit-breaker"
```

And then execute:

```
  $ bundle
```

Or install it yourself as:

```
  $ gem install shift-circuit-breaker
```

## Usage

Example usage is as follows - 

```ruby
  class MyClass
    CIRCUIT_BREAKER = Shift::CircuitBreaker.new(:some_identifier, 
                                                error_threshold: 10, 
                                                skip_duration: 60, 
                                                additional_exception_classes: [ 
                                                  ::Faraday::ClientError
                                                ]
                                              )

    def do_something
      CIRCUIT_BREAKER.call
        operation: -> { SomeService.new(name: 'test').perform_task },
        fallback:  -> { [ 1, 2, 3, 4, 5 ].sum }
    end
  end
```

***Note:***  the `operation` and `fallback` should implement the public method `#call` or wrapped in a `Proc/Lambda`.

With regards to monitoring and logging, integration with New Relic and Sentry is included. To enable any of these features, please set the relevant configurations in an initializer (eg. `shift_circuit_breaker.rb`) as follows -

```ruby
  require "shift/circuit_breaker"

  Shift::CircuitBreaker.configure do |config|
    config.new_relic_license_key = ENV["NEW_RELIC_LICENSE_KEY"]
    config.new_relic_app_name    = ENV["NEW_RELIC_APP_NAME"]
    config.sentry_dsn            = ENV["SENTRY_DSN"]
    config.sentry_environments   = %w[ production ]
  end
```

***Note:*** both integrations can be overriden when instantiating the `Shift::CircuitMonitor` and `Shift::CircuitLogger` services, eg.

```ruby
  CIRCUIT_BREAKER = Shift::CircuitBreaker.new(:some_identifier, 
                                              error_threshold: 10, 
                                              skip_duration: 60, 
                                              logger: Shift::CircuitBreaker::CircuitLogger.new(remote_logger: CUSTOM_LOGGER),
                                              monitor: Shift::CircuitBreaker::CircuitMonitor.new(monitor: CUSTOM_MONITOR)
                                            )
```

## Contributing

Bug reports and pull requests are welcome. Please read our documentation on [CONTRIBUTING](CONTRIBUTING.md).
