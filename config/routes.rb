Rails.application.routes.draw do
get 'commentators', to: 'comments#commentators'  
#post 'comments/create'
  devise_for :users
  namespace :api do
    namespace :v1 do
      #get 'movies', to: 'movies#index'
      resources :movies, only: [:show, :index]
    end
    namespace :v2 do
      #get 'movies', to: 'movies#index'
      resources :movies, only: [:show, :index]
    end
  end
  root "home#welcome"
  resources :genres, only: :index do
    member do
      get "movies"
    end
  end
  resources :movies, only: [:index, :show] do
    member do
      get :send_info
      get :delete_comment
      post :add_comment
    end
    collection do
      get :export
    end
  end
  resources :comments do
   
  end
end
