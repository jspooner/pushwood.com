Woodhack::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
  config.action_mailer.default_url_options = { :host => 'pushwood.dev' }
  
  # Facbook app for Pushwood.dev
  config.facebook_prefix  = 'og: http://ogp.me/ns# fb: http://ogp.me/ns/fb# pushwooddev: http://ogp.me/ns/fb/pushwooddev#'

  # Test mailers
  config.action_mailer.delivery_method = :letter_opener

  #########################################################
  # ASSET PIPELINE
  config.assets.compress = false  # Don't compress assets
  config.assets.compile  = true    # Fallback to assets pipeline if a precompiled asset is missed
  config.assets.digest   = false    # Don't generate digests for assets URLs
  config.assets.debug    = true
end

ENV['RAILS_TEST_IP_ADDRESS'] = "70.181.180.115"

# Tire.configure { logger 'log/elasticsearch.log', :level => 'debug' }
