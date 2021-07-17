Rails.application.routes.draw do
  scope module: :api do
    scope module: :v1 do
      scope module: :merchants do
        resources :merchants, controller: :get_all_merchants, only: :index
      end
    end
  end
end
