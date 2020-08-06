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

    # Criteria
    resources :criteria, only: [:index]
  end

  resources :criteria, only: [:show, :new, :edit, :update, :destroy] do
    member do
      get :tree
      post '' => :create, as: :create_sub
    end
    
    # Direct comparisons
    resources :direct_comparisons, only: [:new, :edit, :create, :update]
    resources :magiq_comparisons, only: [:new, :edit, :create, :update]
    resources :pairwise_comparisons, only: [:new, :edit, :create, :update]
  end
  
  # # Criteria
  # controller :criteria do
  #   get 'articles/:article_id/criteria' => :index, as: :criteria_article
  #   get 'criteria/:id/tree'  => :tree,   as: :criteria_tree
  #   get 'criteria/:id'       => :show,   as: :criterion
  #   get 'criteria/:id/new'   => :new,    as: :new_criterion
  #   get 'criteria/:id/edit'  => :edit,   as: :edit_criterion
  #   post 'criteria/:id'      => :create, as: :create_sub_criterion
  #   patch 'criteria/:id'     => :update
  #   put 'criteria/:id'       => :update
  #   delete 'criteria/:id'    => :destroy
  # end

  # Appraisal
  # controller :appraisals do
  #   get 'criteria/:criterion_id/appraisals/direct'   => :direct,   as: :criterion_appraisal_direct
  #   get 'criteria/:criterion_id/appraisals/rank'     => :rank,     as: :criterion_appraisal_rank
  #   get 'criteria/:criterion_id/appraisals/pairwise' => :pairwise, as: :criterion_appraisal_pairwise
  #   post 'criteria/:criterion_id/appraisals'         => :create,   as: :create_criterion_appraisal
  #   patch 'appraisals/:id'                           => :update,   as: :update_appraisal
  #   delete 'appraisals/:id'                          => :update,   as: :destroy_appraisal
  # end

end
