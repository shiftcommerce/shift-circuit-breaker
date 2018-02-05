[ ![Codeship Status for shiftcommerce/shift-circuit-breaker](https://app.codeship.com/projects/76d6b9e0-ecaa-0135-f112-7a88d47e1dcf/status?branch=master)](https://app.codeship.com/projects/270371)

# Shift Circuit Breaker

The Shift Circuit Breaker library implements a generic mechanism for detecting, monitoring and controlling external service calls that will most-likely fail at some point (e.g. timeout) and cause request queuing. Although a plethora of Ruby circuit breaker libraries exist, those that are frequently updated have a dependency on Redis for persistence. We required a solution that didn't depend on persisting to a shared data store, i.e. a library that stores counters in local memory. As a result, the Shift Circuit Breaker was born.

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
                                                skip_duration: 1.minute, 
                                                additional_exception_classes: [ 
                                                  ::Savon::HTTPError
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


With regards to monitoring, integration with New Relic is included by default. Similarly, integration with Sentry for logging is included by default. To enable any of these features, please set the relevant configuration in an initializer as follows -

```ruby
  Shift::CircuitBreaker.configure do |config|
    config.new_relic_license_key = ENV["NEW_RELIC_LICENSE_KEY"]
    config.new_relic_app_name    = ENV["NEW_RELIC_APP_NAME"]
    config.sentry_dsn            = ENV["SENTRY_DSN"]
    config.sentry_environments   = %w[ production ]
  end
```

***Note:*** both integrations can be overriden when instantiating both the `Shift::CircuitMonitor` and `Shift::CircuitLogger` services.
