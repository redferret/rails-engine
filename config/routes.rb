Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      scope module: :merchants do
        scope :merchants do
          resource :find, controller: :search_merchant, only: :show
        end
        resources :merchants, controller: :resources do
          resources :items, controller: :merchant_items, only: :index
        end
      end
      scope module: :items do
        scope :items do
          resources :find_all, controller: :search_items, only: :index
        end
        resources :items, only: [] do
          resource :merchant, controller: :item_merchant, only: :show
        end
        resources :items, controller: :resources
      end
    end
  end
end
