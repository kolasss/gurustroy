Rails.application.routes.draw do
  root 'home#index'

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      # user auth
      get     'auth', to: 'auth#request_sms'
      post    'auth', to: 'auth#verify'
      delete  'auth/tokens', to: 'auth#destroy_token'

      resources :units, except: [:new, :edit, :show]
      resources :categories, except: [:new, :edit, :show] do
        resources :tags, only: [:index, :create]
      end
      resources :tags, only: [:update, :destroy]
      resources :users, except: [:new, :edit] do
        member do
          get :orders
          get :proposals
          put :change_type
        end
        collection do
          put :change_my_type
        end
      end
      resources :orders, except: [:new, :edit] do
        member do
          delete :cancel
          put :finish
        end
        resources :proposals, only: [:index, :create]
      end
      resources :proposals, only: [:show, :update, :destroy] do
        delete :cancel, on: :member
      end
      resources :versions, only: [:index]
    end
  end
end
