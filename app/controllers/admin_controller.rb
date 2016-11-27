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
    @locations_verified          = Location.where(:marker_verified => true).count
    @locations_total             = Location.count
    
    @count_by_state          = ActiveRecord::Base.connection.select_all("SELECT state, count(state) FROM locations WHERE country = 'United States' GROUP BY `state`;")
    @count_verified_by_state = ActiveRecord::Base.connection.select_all("SELECT state, count(state) FROM locations WHERE country = 'United States' AND marker_verified = 1 GROUP BY `state`;")
    
    @count_by_country = ActiveRecord::Base.connection.select_all("SELECT country, count(country) FROM locations GROUP BY country;")
  end
  
  def landing_page_generator
    @response = Tire.search 'development-woodhack::application_locations' do
      facet 'countries', global: true do
        terms :country
      end
      
      facet 'states', :global => true do
        terms :state
      end
    end
  end
  
  def google_static_maps
    params[:page] = 1 unless params.has_key? :page
    @locations = Location.paginate(:page => params[:page])
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
    id_list = @recent_marker_votes.collect { |i| JSON.parse(i)["location_id"] }.uniq
    @locations           = Location.find(:all, id_list ).reorder_by(id_list, &:id).compact
  end
  
end
