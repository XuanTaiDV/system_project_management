Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :projects, only: %i[index show create update destroy] do
        resources :tasks, only: %i[create index]
      end

      resources :tasks, only: %i[update destroy]
      namespace :users do
        post :register
        post :login
      end
    end
  end
end
