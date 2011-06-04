require 'openid/store/filesystem'


Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :twitter, '5QuVbNj4eIEPKfA7ZBlSbA', 'kFrRL1frIs4iBqKczUv2b4GxxcgxJq5b6WOI2fXR0'
  # provider :twitter, 'UDm0mkDKrjhCIO0Tgm2ydw', 'gbuPa9Fqy9S5MhjYe7kfAccKG1YeJkefgTBLKLoPDBE'

  # app_key, app_seceret
  # provider :facebook, '1b749fb4bdd8f5c203ca1e818f9a8753', '6fd278b47004b8dd2743347f7a0b50ac' # coachfuel.com -dev
  provider :facebook, '6e75b145a1670a5ced176a56bd6aad00', '19ab216e59c6445cf6471b5d726bfe22' # pushwood.com
  provider :open_id, OpenID::Store::Filesystem.new('/tmp')

  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
  use OmniAuth::Strategies::OpenID, OpenID::Store::Filesystem.new('/tmp'), :name => 'yahoo', :identifier => 'yahoo.com'
end
