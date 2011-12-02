
require 'rubygems'
require 'spork'  
def rspec_defaults
  ENV["RAILS_ENV"] ||= 'test'
  require File.dirname(__FILE__) + "/../config/environment"
  require 'rspec/rails'  
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}       # Requires supporting ruby files with custom matchers and macros, etc, in spec/support/ and its subdirectories.  
  RSpec.configure do |config|
    config.after(:each) do
      $redis.flushdb                                                      # Flush the Redis database
    end
    config.mock_with :rspec
    config.use_transactional_fixtures = true
    config.include Devise::TestHelpers, :type => :controller              # Include test helpers for Devise
    config.extend ControllerMacros, :type => :controller
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
