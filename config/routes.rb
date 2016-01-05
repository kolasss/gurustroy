Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, except: [:new, :edit]
      resources :tags, except: [:new, :edit]
      resources :categories, except: [:new, :edit]
      resources :units, except: [:new, :edit]
      resources :orders, except: [:new, :edit]
      resources :photos, except: [:new, :edit]
      resources :proposals, except: [:new, :edit]
    end
  end
end
