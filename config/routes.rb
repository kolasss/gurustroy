Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      # user auth
      get  'auth/request_sms'
      post 'auth/verify'

      resources :units, except: [:new, :edit, :show]
      resources :categories, except: [:new, :edit, :show] do
        resources :tags, only: [:index, :create]
      end
      resources :tags, only: [:update, :destroy]
      resources :users, except: [:new, :edit] do
        member do
          get :orders
          get :proposals
        end
      end
      resources :orders, except: [:new, :edit] do
        get :cancel, on: :member
      end
      resources :photos, except: [:new, :edit]
      resources :proposals, except: [:new, :edit]
    end
  end
end
