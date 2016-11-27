require 'rubygems'
require 'spork'
def rspec_defaults
  ENV["RAILS_ENV"] ||= 'test'
  require File.dirname(__FILE__) + "/../config/environment"
  require 'rspec/rails'
  require 'vcr'
  require 'capybara/rails'
  require 'capybara/rspec'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}       # Requires supporting ruby files with custom matchers and macros, etc, in spec/support/ and its subdirectories.  
  
  VCR.configure do |c|
    c.cassette_library_dir = 'spec/cassettes'
    c.hook_into :fakeweb
    c.configure_rspec_metadata! # Configures RSpec to use a VCR cassette for any example tagged with :vcr.
    c.ignore_localhost = true
  end
  
  RSpec.configure do |config|
    config.after(:each) do
      $redis.flushdb                                                      # Flush the Redis database
    end
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.mock_with :rspec
    config.use_transactional_fixtures = true
    config.include Devise::TestHelpers, :type => :controller              # Include test helpers for Devise
    config.extend ControllerMacros, :type => :controller
    
    # Special before and after hooks for tests tagged with :elasticsearch
    config.before(:each, :elasticsearch) do
      [Location].each { |klass| klass.create_search_index }
    end
    config.after(:each, :elasticsearch) do
      [Location].each { |klass| klass.delete_search_index }
    end
    # Add VCR to all tests
    # config.before(:each) do
    #   unless example.metadata[:skip_vcr_reset]
    #     VCR.configuration.cassette_library_dir = 'spec/cassettes'
    #   end
    # end
  end
  
end


# Loading more in this block will cause your tests to run faster. However,
# if you change any configuration or code from libraries loaded here, you'll
# need to restart spork for it take effect.
Spork.prefork do
  rspec_defaults
end
# This code will be run each time you run your specs.
Spork.each_run do
  FactoryGirl.reload
end
# Load rspec defaults for use without rspec
rspec_defaults
