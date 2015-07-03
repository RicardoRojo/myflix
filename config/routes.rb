require 'sidekiq/web'

Myflix::Application.routes.draw do
  root "pages#front"
  get '/home', to: 'videos#index'
  get '/register', to: "users#new", as: "register"
  get '/sign_in', to: "sessions#new", as: "sign_in"
  post '/login', to: "sessions#create"
  delete '/sign_out', to: "sessions#destroy"
  get '/my_queue', to: "queue_items#index", as: "my_queue"
  post '/update_queue', to: "queue_items#update_queue", as: "update_queue"
  get '/people', to: "relationships#index"
  get '/forgot_password', to: "forgot_passwords#new"
  get '/confirm_password_reset', to: "forgot_passwords#confirm"
  get '/expired_token', to: "reset_passwords#expired_token"
  get 'register/:token', to: "users#new_with_token", as: "register_with_token"
  # sidekiq console
  mount Sidekiq::Web, at: "/sidekiq"
  #
  resources :invitations, only: [:new,:create]
  resources :reset_passwords, only: [:show, :create]
  resources :forgot_passwords, only: [:create]
  resources :users, only: [:show,:create]
  resources :videos do
    collection do
      get "/search", to: "videos#search"
    end
    resources :reviews, only: [:create]
  end
  resources :relationships, only: [:create,:destroy]
  resources :queue_items, only: [:create, :destroy]
  resources :categories, only: [:show]
  get 'ui(/:action)', controller: 'ui'
end
