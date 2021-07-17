Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      scope module: :merchants do
        resources :merchants, controller: :resources, only: [:index, :show] do
          resources :items, controller: :merchant_items, only: :index
        end
      end
      namespace :items do
        resources :items, only: [] do
          resource :merchant, controller: :merchant, only: :show
        end
        resources :items
      end
    end
  end
end
