Rails.application.routes.draw do
  root 'home#index'

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      # user auth
      get     'auth', to: 'auth#request_sms'
      post    'auth', to: 'auth#verify'
      delete  'auth/tokens/:token', to: 'auth#destroy_token'

      resources :units, except: [:new, :edit, :show]
      resources :categories, except: [:new, :edit, :show] do
        resources :tags, only: [:index, :create]
      end
      resources :tags, only: [:update, :destroy]
      resources :users, except: [:new, :edit] do
        member do
          get :orders
          get :proposals
          get :change_type
        end
      end
      resources :orders, except: [:new, :edit] do
        member do
          get :cancel
          get :finish
        end
        resources :proposals, only: [:index, :create]
      end
      resources :proposals, only: [:show, :update, :destroy] do
        get :cancel, on: :member
      end
    end
  end
end
