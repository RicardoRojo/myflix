Myflix::Application.routes.draw do
  root "videos#index"
  get '/home', to: 'videos#index'
  resources :videos do
    collection do
      get "/search", to: "videos#search"
    end
  end
  resources :categories, only: [:show]
  get 'ui(/:action)', controller: 'ui'
end
