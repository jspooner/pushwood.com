Woodhack::Application.routes.draw do

  resources :cd_pages
  
  # match 'geo/search' => 'geo#search' 
  # match 'geo/ios/1/search' => 'geo#ios_search' 
  
  # match 'api/v1/geo/search'
  # # match 'api/v1/geo/cities' states, etc...
  # match 'api/v1/locations/search'

  namespace :api do
    namespace :v1 do
    # Directs /admin/products/* to Admin::ProductsController
      # (app/controllers/admin/products_controller.rb)
      resources :locations do
        collection do
          get 'countries' 
          get 'states' 
          get 'cities' 
          get 'search'
        end
      end
    end
  end
  

  resources :locations do
    get 'images'
  end

  resources :tricks

  get "welcome/index"

  root :to => "welcome#index"

  # auth
  match '/auth/:provider/callback' => 'authentications#create'  
  devise_for :users, :controllers => {:registrations => 'registrations'}, :path_names => { :sign_in => 'login', :sign_out => 'logout' }
  resources :authentications
end


# This is a legacy wild controller route that's not recommended for RESTful applications.
# Note: This route will make all actions in every controller accessible via GET requests.
# match ':controller(/:action(/:id(.:format)))'


# The priority is based upon order of creation:
# first created -> highest priority.

# Sample of regular route:
#   match 'products/:id' => 'catalog#view'
# Keep in mind you can assign values other than :controller and :action

# Sample of named route:
#   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
# This route can be invoked with purchase_url(:id => product.id)

# Sample resource route (maps HTTP verbs to controller actions automatically):
#   resources :products

# Sample resource route with options:
#   resources :products do
#     member do
#       get 'short'
#       post 'toggle'
#     end
#
#     collection do
#       get 'sold'
#     end
#   end

# Sample resource route with sub-resources:
#   resources :products do
#     resources :comments, :sales
#     resource :seller
#   end

# Sample resource route with more complex sub-resources
#   resources :products do
#     resources :comments
#     resources :sales do
#       get 'recent', :on => :collection
#     end
#   end

# Sample resource route within a namespace:
#   namespace :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
#   end

# You can have the root of your site routed with "root"
# just remember to delete public/index.html.
