class Image < ActiveRecord::Base
  belongs_to :location
  has_attached_file :img,
                    :url => "/system/uploads/images/:id/:style.:extension",
                    :styles => { 
                      :iosThumbnail => ["320x240", :jpg],
                      :thumbnail => ["320>280<x320", :jpg],
                      
                      :xlarge => ["800x598>",:jpg],
                      :large => ["300x224>",:jpg],
                      :medium => ["200x149>",:jpg],
                      :tiny => ["100x75>",:jpg]
                    }
end