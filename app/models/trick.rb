class Trick < ActiveRecord::Base
  has_attached_file :image, :styles => { :mobile_thumb => "145#x145#", :mobile => "320x320>", :medium => "345x345>", :thumb => "100x100>" }
  validates_presence_of :lat, :lng
end
