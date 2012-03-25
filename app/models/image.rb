class Image < ActiveRecord::Base
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
  # PROTECTED/PRIVATE METHODS 

end

