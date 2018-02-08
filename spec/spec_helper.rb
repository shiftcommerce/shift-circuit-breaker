# frozen_string_literal: true

require "active_support/core_ext/numeric/time"
require "rspec"
require "pry"
require "securerandom"
require "shift/circuit_breaker"
require "timecop"

ENV["RACK_ENV"] ||= "test"

Timecop.safe_mode = true

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
    expectations.on_potential_false_positives = :nothing
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
