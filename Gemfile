source 'http://rubygems.org'

gem 'rake', '~> 0.8.7'
gem 'rails', '~> 3.1.0'
gem 'mysql2'
gem "rpm_contrib" # requires and loads newrelic_rpm


gem 'json'

gem 'jquery-rails'

gem 'devise', "~> 1.4.5"
gem "devise_invitable", "~> 0.5.4"

gem 'cancan'
gem 'omniauth'

gem "paperclip", "~> 2.3"
gem 'hpricot'
gem 'geocoder'
gem 'vestal_versions', :git => 'https://github.com/jodosha/vestal_versions.git' # for rails 3.1
gem 'acts_as_commentable'
gem 'ajaxful_rating', :git => 'https://github.com/edgarjs/ajaxful-rating.git', :branch => 'rails3'

gem "paperclip", "~> 2.3"
gem "paperclip-facecrop"
gem "rabl"
gem 'will_paginate', :git => "git://github.com/akitaonrails/will_paginate.git", :branch => "rails3.1"
gem "rails-backbone", "~> 0.5.4"


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
  gem 'capistrano', :git => "git://github.com/capistrano/capistrano.git", :tag => "2.5.21"
  gem 'capistrano_colors'
  gem 'rails-footnotes', '>= 3.7'
  gem "letter_opener"
end
group :test do
  gem 'rails3-generators' #mainly for factory_girl
  # gem 'factory_girl'
  gem "factory_girl_rails", ">= 1.0.0"
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
  gem "factory_girl_generator", ">= 0.0.1"
end