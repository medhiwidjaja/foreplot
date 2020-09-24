Rails.application.routes.draw do

  # Devise
  devise_for :users
  root to: "home#index"
  
  # Users
  resources :users
  get  '/signup' => 'users#signup'
  post 'signup' => 'users#create'

  # Articles
  resources :articles do
    collection do 
      get :my
    end
    
    # Alternatives
    resources :alternatives, shallow: true do
      collection do
        post :update_all
      end
    end

    # Criteria
    resources :criteria, only: [:index]

    # Ratings
    resources :ratings, only: [:index]
  end

  # Results
  get '/articles/:article_id/results' => 'results#index', as: :article_results
  get '/articles/:article_id/chart'   => 'results#chart', as: :article_chart

  # Visualization
  get '/articles/:article_id/viz'     => 'viz#index',    as: :article_viz
  get '/articles/:article_id/sankey'  => 'viz#sankey',   as: :article_sankey

  # Benefit Cost Analysis (Feasibility)
  get '/articles/:article_id/feasibility' => 'feasibility#index',  as: :article_feasibility

  # Sensitivity Analysis 
  get '/articles/:article_id/sensitivity' => 'sensitivity#index',  as: :article_sensitivity

  resources :criteria, only: [:show, :edit, :update, :destroy] do
    member do
      get :tree
      get 'new' => :new, as: :new
      post '' => :create, as: :create_sub
    end
    
    controller :direct_comparisons do
      get 'direct_comparisons/new'  => :new,    as: :new_direct_comparisons
      get 'direct_comparisons/edit' => :edit,   as: :edit_direct_comparisons
      post 'direct_comparisons'     => :create, as: :direct_comparisons
      patch 'direct_comparisons'    => :update
      put 'direct_comparisons'      => :update
    end

    controller :magiq_comparisons do
      get 'magiq_comparisons/new'  => :new,    as: :new_magiq_comparisons
      get 'magiq_comparisons/edit' => :edit,   as: :edit_magiq_comparisons
      post 'magiq_comparisons'     => :create, as: :magiq_comparisons
      patch 'magiq_comparisons'    => :update
      put 'magiq_comparisons'      => :update
    end

    controller :ahp_comparisons do
      get 'ahp_comparisons/new'  => :new,    as: :new_ahp_comparisons
      get 'ahp_comparisons/edit' => :edit,   as: :edit_ahp_comparisons
      post 'ahp_comparisons'     => :create, as: :ahp_comparisons
      patch 'ahp_comparisons'    => :update
      put 'ahp_comparisons'      => :update
    end

    controller :ratings do
      get 'ratings' => :show, as: :ratings
    end
  end

end
