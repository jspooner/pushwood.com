Woodhack::Application.routes.draw do


  namespace :admin do
    resources :users
    resources :roles
  end
  
  get "admin/index"
  # get "admin/users"
  # post "admin/users/update"
  get "admin/locations"
  get "admin/duplicates"
  get "admin/parkskaters"
  get "admin/skateparkcom"
  get "admin/marker_verification"

  match 'search' => 'search#index'

  match 'archive/' => 'archive#index', :as => :archive
  match 'archive/:country/' => 'archive#country', :as => :archive_country
  match 'archive/:country/:state/' => 'archive#state', :as => :archive_state
  match 'archive/:country/:state/:city' => 'archive#city', :as => :archive_city

  
  namespace :api do
    namespace :v1 do
      resources :locations do
        collection do
          get 'countries'
          get 'states'
          get 'cities'
          get 'search'
        end
      end
      resources :ratings
      resources :images
      get "authentication/login"
      post "authentication/login"
      post "authentication/create"
      get "authentication/exists"
    end
  end
  
  resources :locations do
    get 'images'
    resources :comments
    member do
      post 'verify_marker'
      post 'rate'
      get 'revert'
    end
  end

  get "welcome/index"
  get "support", :to => "welcome#support"
  get "terms_of_service", :to => "welcome#terms_of_service"
  
  # skateparks/:country/:state/:location
  get "skateparks/:country/:location", :to => "browse#location"
  get "skateparks/:country", :to => "browse#country"
  get "skateparks", :to => "browse#index"

  
  # auth
  match '/auth/:provider/callback' => 'authentications#create'  
  devise_for :users#, :controllers => {:registrations => 'registrations'}, :path_names => { :sign_in => 'login', :sign_out => 'logout' }
  resources :authentications
  
  root :to => "welcome#index"
  
  
end