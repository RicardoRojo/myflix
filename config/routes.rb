Myflix::Application.routes.draw do
  root "pages#front"
  get '/home', to: 'videos#index'
  get '/register', to: "users#new", as: "register"
  get '/sign_in', to: "sessions#new", as: "sign_in"
  post '/login', to: "sessions#create"
  delete '/sign_out', to: "sessions#destroy"
  resources :users, only: [:create]
  resources :videos do
    collection do
      get "/search", to: "videos#search"
    end
    resources :reviews, only: [:create]
  end
  resources :categories, only: [:show]
  get 'ui(/:action)', controller: 'ui'
end
