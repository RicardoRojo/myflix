Myflix::Application.routes.draw do
  root "pages#front"
  get '/home', to: 'videos#index'
  get '/register', to: "users#new", as: "register"
  get '/sign_in', to: "sessions#new", as: "sign_in"
  post '/login', to: "sessions#create"
  get '/sign_out', to: "sessions#destroy"
  resources :users, only: [:create]
  resources :videos do
    collection do
      get "/search", to: "videos#search"
    end
  end
  resources :categories, only: [:show]
  get 'ui(/:action)', controller: 'ui'
end
