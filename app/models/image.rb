require 'net/https'
require 'uri'
class Image < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  # Rails.application.routes.default_url_options[:host] = 'http://pushwood.com/'
  # SERIALIZED ATTRIBUTES 
  # CONSTANTS 
  # SCOPES
  scope :approved, where("approved = 1")
  scope :unapproved, where("approved = 0")
  default_scope order('created_at desc')
  # RELATIONSHIPS 
  belongs_to :user
  belongs_to :location, :counter_cache => true 
  # ATTRIBUTE ACCESSORS 
  attr_accessor :share_on_fb
  # GEM CONFIGURATIONS E.G., ACTS_AS_AUTHENTIC 
  after_update :post_to_facebook
  
  has_attached_file :img,
                    :url => "/system/uploads/images/:id/:style.:extension",
                    :styles => { 
                      # v1 api for detail view on location
                      # :iosThumbnail => ["320x240", :jpg],
                      :iosThumbnail => ["640x480", :jpg],
                      # v1 api, large view for iphone
                      :iosLarge => ["1280x1920", :jpg],
                      # :iosMedium => ["640x960", :jpg],
                      :iosMedium => {:geometry => "640x960", :format => :jpg},
                      # v1 api, small images in image grid 
                      :iosSmall => {:geometry => "75x75#", :format => :jpg, :processors=>[:face_crop]}, 
                      # show location large slideshow
                      :xlarge => ["800x598>",:jpg],
                      # v1 api, home page
                      :large => ["300x224>",:jpg],
                      # show location (grid of photos)
                      :large_sq => ["262x149>",:jpg],
                      # edit locations
                      :tiny => ["100x75>",:jpg]
                    }
  # VALIDATIONS AND CALLBACKS 
  # CLASS METHODS 
  # INSTANCE METHODS
  def curl_photograph
    "- F access_token=#{user.facebook_access_token} -F skate_park=#{location_url(location)} https://graph.facebook.com/me/pushwood:photograph"
  end

  def post_to_facebook
    logger.info { "post_to_facebook-------------------------- #{share_on_fb}" }
    return if share_on_fb != "true" and (!user.nil? or !user.facebook_access_token.nil? or !location.nil?)
    post = {
      :message => "I posted a photo of #{location.name}",
      :picture => "#{Rails.application.routes.default_url_options[:host]}#{img.url(:thumb)}",
      :link => location_url(location, :host => Rails.configuration.action_mailer['default_url_options'][:host]),
      :name => location.name,
      :description => location.ios_description
    }
    logger.info { "POSTING... post_to_facebook--------------------------  #{post}" }
    me = FbGraph::User.me(user.facebook_access_token)
    me.feed!(post)
    
    # curl -F 'access_token=AAAC4m77AVg8BAAvKse9MQ00jYmaeslpYbTYgZBDcG8jn4elTrTgZAeZCF2sKZBIa2wgixqwwy34B5fCRX22WJk2wf9yrCeUZD' \
    #      -F 'skate_park=http://pushwood.com/locations/3255-homage-brooklyn' \
    #         'https://graph.facebook.com/me/pushwood:photograph'
    

    # uri              = URI.parse('https://graph.facebook.com/me/pushwood:photograph')
    # http             = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl     = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    # http.ca_file = File.join("/Users/jonathanspooner/", "cacert.pem") 
    # puts http.post('https://graph.facebook.com/me/pushwood:photograph', "access_token=#{user.facebook_access_token}&skate_park=#{location_url(location)}")


    # res = http.post_form(uri, 'access_token' => user.facebook_access_token, 'skate_park' => location_url(location))
    # logger.info { "post_to_facebook--------------------------  #{res.body}" }
  end
  # PROTECTED/PRIVATE METHODS
  private

end

