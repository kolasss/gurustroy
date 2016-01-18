Rails.application.routes.draw do

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :units, except: [:new, :edit, :show]
      resources :categories, except: [:new, :edit, :show]
      resources :users, except: [:new, :edit]
      # resources :auth, except: [:new, :edit]
      get 'auth/request_sms'
      post 'auth/verify'
      resources :tags, except: [:new, :edit]
      resources :orders, except: [:new, :edit]
      resources :photos, except: [:new, :edit]
      resources :proposals, except: [:new, :edit]
    end
  end
end
