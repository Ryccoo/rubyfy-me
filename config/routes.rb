Rails.application.routes.draw do
  get 'home/index'

  resources :benchmarks, only: [:index, :show]

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
      resources :results, only: [:index, :show]
    end
  end
end
