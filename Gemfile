source 'http://rubygems.org'

gem 'rails', '3.0.8'

gem 'jquery-rails'

gem 'devise', "1.1.7"
gem 'devise_invitable', "0.3.5"
# gem 'ruby-mysql'#, "2.9.3"
gem 'mysql'
gem 'newrelic_rpm'
gem 'cancan'
gem 'omniauth'
gem "paperclip", "~> 2.3"

gem 'hpricot'
gem 'geocoder',    :git => 'git://github.com/jspooner/geocoder.git'
gem 'rails_admin', :git => 'git://github.com/sferik/rails_admin.git'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19'

# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
group :test do
  gem "factory_girl_rails", ">= 1.0.0", :group => :test
  gem "factory_girl_generator", ">= 0.0.1", :group => [:development, :test]
  gem "rspec-rails", ">= 2.2.1", :group => [:development, :test]
end