Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      scope :revenue do
        resources :merchants, controller: :revenue, module: :merchants, only: [:index, :show]
        resources :items, controller: :revenue, module: :items, only: :index
      end

      namespace :merchants do
        resource :find, controller: :search_merchant, only: :show
        resources :most_items, only: :index
      end

      resources :merchants, controller: :resources, module: :merchants do
        resources :items, only: :index
      end

      namespace :items do
        resources :find_all, controller: :search_items, only: :index
      end
      
      resources :items, controller: :resources, module: :items do
        resource :merchant, controller: :merchant, only: :show
      end
    end
  end
end
