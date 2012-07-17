require 'openid/store/filesystem'


Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :twitter, '5QuVbNj4eIEPKfA7ZBlSbA', 'kFrRL1frIs4iBqKczUv2b4GxxcgxJq5b6WOI2fXR0'
  # provider :twitter, 'UDm0mkDKrjhCIO0Tgm2ydw', 'gbuPa9Fqy9S5MhjYe7kfAccKG1YeJkefgTBLKLoPDBE'

  # app_key, app_seceret
  # provider :facebook, '202979059717647', '19ab216e59c6445cf6471b5d726bfe22' # pushwood.com
  provider :facebook, Woodhack::Application.config.facebook_id, Woodhack::Application.config.facebook_seceret, {:scope => 'email'}
  provider :open_id, OpenID::Store::Filesystem.new('/tmp')

  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'yahoo', :identifier => 'yahoo.com'
end

if Rails.env == "production"
  OmniAuth.config.full_host = 'http://pushwood.com'
end
