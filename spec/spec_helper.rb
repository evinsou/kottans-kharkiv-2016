require_relative '../app.rb'  
require 'rspec'  
require 'rack/test'
require 'factory_girl'
require 'rspec/timecop'
require 'database_cleaner'
require 'sinatra/activerecord'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
    mocks.syntax = [:expect]
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end
 
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end
 
  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end
 
  config.before(:each) do
    DatabaseCleaner.start
  end
 
  config.after(:each) do
    DatabaseCleaner.clean
  end
end

ActiveRecord::Base.logger = nil unless ENV['LOG'] == true

FactoryGirl.definition_file_paths = %w{./factories ./spec/factories}
FactoryGirl.find_definitions
