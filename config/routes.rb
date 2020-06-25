Rails.application.routes.draw do

  # Devise
  devise_for :users
  root to: "home#index"
  
  # Users
  resources :users
  get  '/signup' => 'users#signup'
  post '/signup' => 'users#create'

  # Articles
  resources :articles do
    collection do 
      get :my
    end
    
    # Alternatives
    resources :alternatives, shallow: true
    member do
      patch :update_alternatives
    end
  end
  
  # Criteria
  get '/articles/:article_id/criteria' => 'criteria#index', as: :article_criteria
  get '/criteria/:id/tree'  => 'criteria#tree', as: :criteria_tree
  get '/criteria/:id'       => 'criteria#show', as: :criterion
  get '/criteria/:id/new'   => 'criteria#new',  as: :new_criterion
  get '/criteria/:id/edit'  => 'criteria#edit', as: :edit_criterion
  post '/criteria/:id'      => 'criteria#create', as: :create_sub_criterion
  patch '/criteria/:id'     => 'criteria#update'
  put '/criteria/:id'       => 'criteria#update'
  delete '/criteria/:id'    => 'criteria#destroy'

end
