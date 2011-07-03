class Image < ActiveRecord::Base
  belongs_to :location
  has_attached_file :img,
                    # :default_url => "/images/defaults/:attachment/:style.jpg",
                    :styles => { 
                      :profile => ["280>280<x300", :jpg], 
                      :detail => ["200>200<x200", :jpg], 
                      :thumb => ["90x90>",:jpg],
                      :tiny => ["20x20>",:jpg],
                    }
end
