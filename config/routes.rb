Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  root 'posts#index'

  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'  
  delete '/logout', to: 'sessions#destroy', as: 'logout_path'

  resources :meetings do
    member do
      post :join
      delete :leave
    end
  end

  get '/profile', to: 'users#index', as: 'profile'
  get '/profile/:username', to: 'users#show', as: 'user_profile'

  resources :posts do
    resources :stars, only: [:create]
    delete 'star', to: 'stars#destroy'
    resources :comments
  end

  resources :chats do
    resources :messages
    post 'create_message', on: :member
  end

  get 'search', to: 'users#search'
  get 'new_chat', to: 'chats#new'
  patch 'update_role', to: 'users#update_role'
  
end
