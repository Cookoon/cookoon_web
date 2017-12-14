Rails.application.routes.draw do

  mount Attachinary::Engine => "/attachinary"
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions', invitations: 'users/invitations' }

  # Different root for authenticated users
  authenticated do
    root 'cookoons#index'
  end
  root 'pages#home'

  resource :users, only: [:edit, :update]
  resources :users, only: [:index] do
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
  end
  resources :user_searches, only: :create
  resources :stripe_accounts, only: [:new, :create]
  resources :credit_cards, only: [:index, :create, :destroy]

  resources :cookoons do
    resources :reservations, only: [:create]
  end

  resources :reservations, only: [:index, :show, :edit, :update] do
    resources :payments, only: [:new, :create]
  end

  # -------- HOST NAMESPACE ---------
  namespace :host do
    resources :reservations, only: [:index, :edit, :update] do
      resources :inventories, only: [:new, :create]
    end
    resources :inventories, only: [:edit, :update]
    get 'dashboard', to: 'users#dashboard'
  end

  # -------- CUSTOM ROUTES ---------
  get 'setcookies', to: 'pages#setcookies'
  get 'apple-app-site-association', to: 'pages#apple_app_site_association'
  get '/.well-known/assetlinks.json', to: 'pages#android_assetlinks'
  get 'support', to: 'pages#support'
  get 'conditions-generales', to: 'pages#cgu', as: :cgu
  get 'en-savoir-plus', to: 'pages#about'
  get 'en-savoir-plus/louer-un-cookoon', to: 'pages#about_rent'
  get 'en-savoir-plus/devenir-hote', to: 'pages#about_hosting'
  get 'en-savoir-plus/garanties-cookoon', to: 'pages#about_warranties'
end
