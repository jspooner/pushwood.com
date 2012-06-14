source 'http://rubygems.org'

gem 'rake', '~> 0.8.7'
gem 'rails', '~> 3.1.3'
gem 'mysql2'
gem "rpm_contrib" # requires and loads newrelic_rpm

gem 'json'
gem 'jquery-rails'
gem 'gon', '2.0.3'

gem 'devise', "~> 1.4.5"
gem "devise_invitable", "~> 0.5.4"

gem "cancan", "1.6.7"
gem 'omniauth'

gem 'redis', '2.2.2'
gem "redis-objects", "~> 0.5.2"
gem 'nokogiri'

gem 'hpricot'
gem 'geocoder'
gem 'vestal_versions', :git => 'https://github.com/jodosha/vestal_versions.git' # for rails 3.1
gem 'acts_as_commentable'
gem 'ajaxful_rating', :git => 'https://github.com/edgarjs/ajaxful-rating.git', :branch => 'rails3'

gem "paperclip", "~> 2.3"
gem "paperclip-facecrop"
gem "rabl"
gem 'will_paginate', '~> 3.0.2'
gem "rails-backbone", "~> 0.5.4"

gem 'geoplanet'
gem 'ancestry'
gem 'carmen'
gem 'fb_graph'

group :production do
  gem 'unicorn'
end

# # Rails 3.1 - Asset Pipeline
# gem "sass-rails", "~> 3.1.2" # This should be within the :assets group but activeadmin breaks if it's not.
# group :assets do
#   gem 'execjs'
#   gem 'therubyracer'
#   gem 'sass'
#   gem 'coffee-rails', "~> 3.1.0.rc"
#   gem 'uglifier'
# end

group :assets do
  gem 'sass-rails'#, "  ~> 3.1.0.rc"
  gem 'coffee-rails'#, "~> 3.1.0.rc"
  gem 'execjs'
  gem 'therubyracer'
  gem 'sass'
  gem 'uglifier'
end
group :development do
  gem 'brewdler'
  gem 'syntax'
  gem 'spork', '=0.9.0.rc9'
  gem 'capistrano'#, :git => "git://github.com/capistrano/capistrano.git", :tag => "2.5.21"
  gem 'capistrano-ext'
  gem 'capistrano_colors'
  gem "letter_opener"
end
group :test do
  gem 'rails3-generators' #mainly for factory_girl
  gem 'factory_girl'
  gem "cucumber-rails", ">= 1.0.2"
  gem "capybara", ">= 1.0.0"
  gem "database_cleaner", ">= 0.6.7"
  gem "launchy", ">= 2.0.5"
  gem "resque_spec"
  gem "selenium-client"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
end
group :test, :development do
  gem "rspec-rails", ">= 2.6.1" # Needs to be in Dev group for rake tasks
  # gem "ruby-prof"
end
gem 'rubber'
gem 'open4'
