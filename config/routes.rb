Rails.application.routes.draw do
  scope module: :api do
    scope module: :v1 do
      scope module: :merchants do
        resources :merchants, controller: :get_all_merchants, only: :index
        resources :merchant, controller: :get_merchant, only: :show
        resources :merchant, only: [] do
          resources :items, controller: :get_merchant_items, only: :index
        end
      end
    end
  end
end
