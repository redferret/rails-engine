Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      scope :revenue do
        resources :merchants, controller: :revenue, module: :merchants, only: :index
      end
      namespace :merchants do
        resource :find, controller: :search_merchant, only: :show
      end
      resources :merchants, controller: :resources, module: :merchants do
        resources :items, controller: :merchant_items, only: :index
      end
      namespace :items do
        resources :find_all, controller: :search_items, only: :index
      end
      scope module: :items do
        resources :items, only: [] do
          resource :merchant, controller: :item_merchant, only: :show
        end
        resources :items, controller: :resources
      end
    end
  end
end
