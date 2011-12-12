class AdminController < Admin::BaseController
  def index
  end

  def users
    @users = User.order('created_at DESC').paginate(:page => params[:page], :per_page => 30)
  end

  def locations
    @locations_with_descriptions = Location.where("description IS NOT NULL").count
    @locations_with_images       = Location.where("images_count > 0").count
    @locations_with_ratings      = Location.where("rating_average > 0").count
    @locations_total             = Location.count
    
    @count_by_state   = ActiveRecord::Base.connection.select_all("SELECT state, count(state) FROM locations WHERE country = 'United States' GROUP BY `state`;")
    @count_by_country = ActiveRecord::Base.connection.select_all("SELECT country, count(country) FROM locations GROUP BY country;")
  end
  
  def duplicates
    @duplicates = Location.find_duplicate_locations || []
  end
  
  def parkskaters
  end
  
  def skateparkcom
  end
  
  def marker_verification
    @recent_marker_votes = Location.recent_marker_votes
    id_list = @recent_marker_votes.collect { |i| JSON.parse(i)["location_id"] }
    @locations           = Location.find( id_list ).reorder_by(id_list, &:id)
  end
  
end
