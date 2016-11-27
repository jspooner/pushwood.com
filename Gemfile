source 'http://rubygems.org'

gem 'rake'
gem 'rails', '~> 3.2.14'
gem 'mysql2'
gem "rpm_contrib" # requires and loads newrelic_rpm

gem 'json'
gem "jquery-rails"
gem 'gon'
gem 'display_case'

gem 'devise'
gem "devise_invitable"
gem "devise-encryptable"

gem "cancan"
gem 'omniauth'
gem 'omniauth-facebook'
gem "oa-openid"

gem 'redis'
gem "redis-objects"

gem 'nokogiri'
gem 'hpricot'

gem 'geocoder'
gem 'geoplanet'

gem 'vestal_versions', :git => 'https://github.com/jodosha/vestal_versions.git' # for rails 3.1
gem 'acts_as_commentable'
gem 'ajaxful_rating', :git => 'https://github.com/edgarjs/ajaxful-rating.git', :branch => 'rails3'

gem "paperclip"
gem "paperclip-facecrop"
gem "rabl"
gem 'will_paginate'
gem 'ancestry'
gem "carmen" # Geo database
gem 'tire'

gem 'sidekiq'
gem 'slim' # 4 sidekiq
gem 'sinatra', :require => nil # 4 sidekiq

gem 'acts_as_elo'
gem 'fb_graph'

gem 'twitter-bootstrap-rails'
gem 'less-rails'
gem "therubyracer"

gem 'rubber'
gem 'open4'

group :assets do
  gem 'coffee-rails'#, "~> 3.1.0.rc"
  gem 'execjs'
  gem 'uglifier'
end
group :development do
  gem 'guard-rspec'
  gem 'rb-fsevent', '~> 0.9.1'
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
  gem "cucumber-rails", :require => false
  gem "database_cleaner"
  gem "launchy"
  gem "resque_spec"
  gem "selenium-client"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "vcr"
  gem "fakeweb"
end
group :test, :development do
  gem "rspec-rails"
  gem "capybara"
end
