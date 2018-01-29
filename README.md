# Shift Circuit Breaker

The Shift Circuit Breaker library implements a generic mechanism for detecting, monitoring and controlling external service calls that will most-likely fail (eg. timeout) and cause request queuing. 

Similar to a conventional circuit breaker, when a circuit is closed it allows operations to flow through. When the `error_threshold` is exceeded (tripped), the circuit is then opened for the defined `skip_duration`, ie. no operations are executed and the provided `fallback` is called.

## Installation

Add this line to your application's Gemfile:

```
  $ gem 'shift-circuit-breaker'
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
                                                  ::Savon::HTTPError, 
                                                  ...
                                                ]
                                              )

    def do_something
      CIRCUIT_BREAKER.call
        operation: -> { SomeService.new(name: 'test').perform_task },
        fallback:  -> { [ 1, 2, 3, 4, 5 ].sum }
    end
  end
```

Note: the `operation` and `fallback` should implement the public method `#call` or wrapped in a `Proc/Lambda`.

## Development

After checking out the repository, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run 

```
  $ bundle exec rake install
``` 

To release a new version, update the version number in `lib/shift/circuit_breaker/version.rb`, and then run 

```
  $ bundle exec rake release
``` 

This will create a tag, push to GitHub and push your latest version to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/shift-circuit-breaker/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
