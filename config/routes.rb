Rails.application.routes.draw do
  mount Attachinary::Engine => '/attachinary'

  devise_for :users, controllers: {
    invitations: 'users/invitations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

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
    resources :invoices, only: [:create]
  end

  # -------- HOST NAMESPACE ---------
  namespace :host do
    resources :reservations, only: [:index, :edit, :update] do
      resources :inventories, only: [:new, :create]
    end
    resources :inventories, only: [:edit, :update]
    get 'dashboard', to: 'users#dashboard'
  end

  get 'setcookies', to: 'pages#setcookies'
  get 'apple-app-site-association', to: 'pages#apple_app_site_association'
  get '.well-known/apple-app-site-association', to: 'pages#apple_app_site_association'
  get '.well-known/assetlinks.json', to: 'pages#android_assetlinks'
  get 'support', to: 'pages#support'
  get 'conditions-generales', to: 'pages#cgu', as: :cgu
  get 'en-savoir-plus', to: 'pages#about'
  get 'en-savoir-plus/louer-un-cookoon', to: 'pages#about_rent'
  get 'en-savoir-plus/devenir-hote', to: 'pages#about_hosting'
  get 'en-savoir-plus/garanties-cookoon', to: 'pages#about_warranties'

  # -------- ADMIN ROUTES ---------
  # Sidekiq Web UI, only for admins.
  require "sidekiq/web"
  authenticate :user, lambda { |u| u.admin } do
    mount Sidekiq::Web => '/sidekiq'
  end

  # ForestAdmin
  namespace :forest do
    post '/actions/award-invitations' => 'users#award_invitations'
  end

  mount ForestLiana::Engine => '/forest'
end
