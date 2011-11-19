class AdminController < ApplicationController
  def index
  end

  def users
  end

  def locations
    @locations_with_descriptions = Location.where("description IS NOT NULL").count
    @locations_with_images       = Location.where("images_count > 0").count
    @locations_with_ratings      = Location.where("rating_average > 0").count
    @locations_total             = Location.count
    @duplicates                  = Location.find_duplicate_locations || []
  end

end
