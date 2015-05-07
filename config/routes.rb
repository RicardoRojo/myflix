Myflix::Application.routes.draw do
  root "videos#index"
  get '/home', to: 'videos#index'
  resources :videos, except: [:index]
  resources :categories, only: [:show]
  get 'ui(/:action)', controller: 'ui'
end
