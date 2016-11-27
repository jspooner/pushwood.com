Woodhack::Application.routes.draw do
  
  get "authentication/create"

  get "elo/images"

  get "battles/skateparks" => "elo#locations"
  get "battles/top-skateparks" =>"elo#top_locations"
  post "elo/vote"

  # get "locations/index"
  
  namespace :admin do
    resources :users
    resources :roles
    resources :images
    get "locations" => "locations#index"
    post "locations/multi_update" => "locations#multi_update"
  end
  
  get "admin/index"
  # get "admin/users"
  # post "admin/users/update"
  get "admin/location_stats" => "admin#locations"
  get "admin/duplicates"
  # get "admin/parkskaters"
  # get "admin/skateparkcom"
  get "admin/marker_verification"
  # get "admin/google_static_maps"

  get "iphone/feed"
  get "iphone/your_images"
  get "iphone/news"
  get "iphone/about"
  get "iphone/help"

  match 'search' => 'search#index'

  
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
    namespace :v2 do
      resources :locations, :only => [:index, :show, :update, :create]
      post "authentication/create"
    end
  end
  
  resources :locations do
    resources :comments
    member do
      post 'verify_marker'
      post 'rate'
      get 'revert'
    end
  end
  
  get "places", :to => "places#index"
  get "places/*id", :to => "places#index"
  
  get "support", :to => "welcome#support"
  get "terms_of_service", :to => "welcome#terms_of_service"
  
  
  # auth
  match '/auth/:provider/callback' => 'authentications#create'  
  devise_for :users#, :controllers => {:registrations => 'registrations'}, :path_names => { :sign_in => 'login', :sign_out => 'logout' }
  resources :authentications
  
  
  require 'sidekiq/web'
  # constraint = lambda { |request| request.env["warden"].authenticate? and request.env['warden'].user.admin? }
  # constraints constraint do
    mount Sidekiq::Web => '/sidekiq'
  # end
  
  # root :to => "places#index"
  # root :to => "elo#locations"
  root :to => "welcome#index"
  
  
end