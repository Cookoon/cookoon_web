Rails.application.routes.draw do

  mount Attachinary::Engine => "/attachinary"
  devise_for :users, controllers: { registrations: 'registrations' }

  # Different root for authenticated users
  authenticated do
    root 'cookoons#index'
  end
  root 'pages#home'

  resource :users, only: [:edit, :update]
  resources :user_searches, only: :create
  resources :stripe_accounts, only: [:new, :create]

  resources :cookoons do
    resources :reservations, only: [:create]
  end

  resources :reservations, only: [:index] do
    resources :paiements, only: [:new, :create]
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
  get 'en-savoir-plus', to: 'pages#about'
  get 'en-savoir-plus/louer-un-cookoon', to: 'pages#about_rent'
  get 'en-savoir-plus/devenir-hote', to: 'pages#about_hosting'
  get 'en-savoir-plus/garanties-cookoon', to: 'pages#about_warranties'
end
