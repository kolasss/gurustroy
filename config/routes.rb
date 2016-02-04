Rails.application.routes.draw do
  root 'home#index'

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      # user auth
      namespace :auth do
        get  :request_sms
        post :verify
        get  :revocate_current
        get  :revocate_other
      end

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
