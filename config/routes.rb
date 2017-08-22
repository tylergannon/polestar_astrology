Rails.application.routes.draw do
  resources :comments, only: [:edit, :update]
  resources :stars, only: [:show, :index] do
    resources :palaces, only: [:index, :show] do
      resources :relationships, only: [:new, :create, :update, :edit, :destroy]
      resources :comments, except: :index
    end
    resources :comments, except: :index
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :charts

  devise_for :members, controllers: {
    omniauth_callbacks: 'auth/omniauth_callbacks'
  }

  resources :pages do
    get :privacy_policy, on: :collection
  end

  root 'charts#index'
end
