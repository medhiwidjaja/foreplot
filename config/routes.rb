Rails.application.routes.draw do

  resources :articles
  devise_for :users
  root to: "home#index"
  
  resources :users
  get  '/signup' => 'users#signup'
  post '/signup' => 'users#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
