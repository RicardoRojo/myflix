Myflix::Application.routes.draw do
  root "pages#front"
  get '/home', to: 'videos#index'
  get '/register', to: "users#new", as: "register"
  get '/sign_in', to: "sessions#new", as: "sign_in"
  post '/login', to: "sessions#create"
  delete '/sign_out', to: "sessions#destroy"
  get '/my_queue', to: "queue_items#index", as: "my_queue"
  resources :users, only: [:create]
  resources :videos do
    collection do
      get "/search", to: "videos#search"
    end
    resources :reviews, only: [:create]
  end
  resources :queue_items, only: [:create, :destroy]
  resources :categories, only: [:show]
  get 'ui(/:action)', controller: 'ui'
end
