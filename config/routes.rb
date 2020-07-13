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
    resources :alternatives, shallow: true
    member do
      patch :update_alternatives
    end
  end
  
  # Criteria
  controller :criteria do
    get 'articles/:article_id/criteria' => :index, as: :criteria_article
    get 'criteria/:id/tree'  => :tree,   as: :criteria_tree
    get 'criteria/:id'       => :show,   as: :criterion
    get 'criteria/:id/new'   => :new,    as: :new_criterion
    get 'criteria/:id/edit'  => :edit,   as: :edit_criterion
    post 'criteria/:id'      => :create, as: :create_sub_criterion
    patch 'criteria/:id'     => :update
    put 'criteria/:id'       => :update
    delete 'criteria/:id'    => :destroy
  end

  # Assay
  controller :assay do
    get 'criteria/:criterion_id/assays/direct'   => :direct,   as: :criterion_assay_direct
    get 'criteria/:criterion_id/assays/rank'     => :rank,     as: :criterion_assay_rank
    get 'criteria/:criterion_id/assays/pairwise' => :pairwise, as: :criterion_assay_pairwise
    post 'criteria/:criterion_id/assays'         => :create,   as: :create_criterion_assay
    patch 'assays/:id'                           => :update,   as: :update_assay
    delete 'assays/:id'                          => :update,   as: :destroy_assay
  end

end
