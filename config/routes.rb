Rails.application.routes.draw do
  resources :custom, only: [] do
    collection do
      get 'parallelism'
    end
  end

  apipie
  get 'home/index'
  get 'hardware', to: 'home#hardware'

  resources :mri, only: [:index, :show] do
    get 'select', on: :collection
    get 'runs', on: :member
  end

  resources :compilers, only: [:index, :show] do
    get 'select', on: :collection
    get 'runs', on: :member
  end

  resources :implementations, only: [:index, :show] do
    get 'select', on: :collection
    get 'runs', on: :member
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  namespace :api, :defaults => { :format => 'json' } do
    namespace :v1 do
      resources :benchmarks, only: [:index, :show] do
        get 'results', on: :member
      end
      resources :ruby_versions, only: [:index, :show] do
        get 'results', on: :member
      end
      resources :results, only: [:index, :show] do
        post '', on: :collection, to: 'results#create', as: 'create_api_result'
      end
    end
  end
end
