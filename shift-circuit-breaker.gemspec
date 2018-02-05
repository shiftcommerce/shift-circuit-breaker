# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "shift/circuit_breaker/version"

Gem::Specification.new do |s|
  s.name        = "shift-circuit-breaker"
  s.version     = Shift::CircuitBreaker::VERSION
  s.platform    = Gem::Platform::RUBY
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

  s.required_ruby_version = ">= 2.0.0"
  s.require_paths = [ "lib" ]

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- { test, spec, features }/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_dependency "activesupport", ">= 3.0.0"
  s.add_dependency "newrelic_rpm", ">= 3.1"
  s.add_dependency "sentry-raven", ">= 1.2.3"

  s.add_development_dependency "rubocop", "~> 0.52.1"
  s.add_development_dependency "rake", "~> 12.3"
  s.add_development_dependency "rspec", "~> 3.7"
  s.add_development_dependency "timecop", "~> 0.9.1"
end
