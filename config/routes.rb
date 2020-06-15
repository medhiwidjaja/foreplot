Rails.application.routes.draw do

  devise_for :users
  root to: "home#index"
  
  resources :users
  get  '/signup' => 'users#signup'
  post '/signup' => 'users#create'

  resources :articles do
    collection do 
      get :my
    end
  end
end
