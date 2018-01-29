$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require "shift/circuit_breaker/version"

Gem::Specification.new do |s|
  s.name        = "shift-circuit-breaker"
  s.version     = Shift::CircuitBreaker::VERSION
  s.summary     = "A generic implementation of the Circuit Breaker pattern in Ruby"
  s.description = <<-DOC
    The library provides a mechanism for detecting, monitoring and controlling slow or 
    unresponsive external service call timeouts, thus preventing cascading system failures. 
  DOC
  s.homepage    = "https://github.com/shiftcommerce/shift-circuit-breaker"
  s.authors     = [ "Mufudzi Masaire" ]
  s.email       = "mufudzi.masaire@shiftcommerce.com"
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.license     = "MIT"

  s.required_ruby_version = '>= 2.0.0'

  s.files         = Dir[ "{lib}/**/**/*.{rb}", "LICENSE", "README.md" ]
  s.test_files    = Dir[ "spec/**/*" ]

  s.add_dependency "activesupport", ">= 3.0.0"
  s.add_dependency "newrelic_rpm", "~> 4.7", ">= 4.7.1.340"
  s.add_dependency "sentry-raven", "~> 2.7", ">= 2.7.1"

  s.add_development_dependency "rake", "~> 12.3"
  s.add_development_dependency "rspec", "~> 3.7"
end
