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
  s.license     = "MIT"

  s.files         = Dir[ "{lib}/**/**/*.{rb}", "LICENSE", "README.md" ]
  s.test_files    = Dir[ "spec/**/*" ]

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
end