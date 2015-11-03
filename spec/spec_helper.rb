require 'rspec'
require 'byebug'
require 'timecapsule'
require 'rails_setup_helper'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  
  config.order = :random

  Kernel.srand config.seed
  
  config.before(:suite) { DatabaseCleaner.strategy = :transaction }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }
end

def silently_do
  warn_level = $VERBOSE
  $VERBOSE = nil
  
  yield
  
  $VERBOSE = warn_level
end
