Miracle::Application.routes.draw do
  root :to => 'home#index'

  match '/tagged/:id' => "posts#tagged"
  match '/search/:q'  => "posts#search"
  resources :posts do
    member do
      get :replies
    end
  end
  resources :friendships, :only => [:create, :destroy]
  resources :tagships, :only => [:create, :destroy]
  
  match '/auth/failure' => 'sessions#failure'
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/login' => 'sessions#new', :as => :login
  match '/auth/:provider/callback' => 'sessions#create'
  resources :users, :only => [ :show, :edit, :update ] do
    collection do
      get :mentions
    end
  end
end
