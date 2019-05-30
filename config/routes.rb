Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create]
      resources :roles, only: [:create]
      resources :permissions, except: [:show, :update]
      resource :role_permissions, only: [:create, :destroy]
    end
  end
end
