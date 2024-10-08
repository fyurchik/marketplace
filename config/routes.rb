Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resource :registration, only: [:create]
      resource :session, only: [:create, :destroy]

      resources :posts do
        collection do
          get 'filter'
        end
      end

      resource :admin_session, only: [:create, :destroy]
      namespace :admin do
        resources :posts, only: [:index] do
          member do
            patch 'update_status'
          end
        end
      end
    end
  end

  # Defines the root path route ("/")
  # root "posts#index"
end
