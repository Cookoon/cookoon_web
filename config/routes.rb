Rails.application.routes.draw do
  mount Attachinary::Engine, at: :attachinary

  devise_for :users, controllers: {
    invitations: 'users/invitations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  # -------- STATIC PAGES ---------
  # Different root for authenticated users
  authenticated { root 'pages#home' }
  root 'pages#welcome'

  controller :pages do
    get :home
    get :support
    get :desktop_only
  end

  namespace :stripe do
    controller :webhooks do
      post :source_chargeable
      post :charge_succeeded
    end
  end

  # -------- RESOURCES ---------
  resource :users, only: %i[edit update]
  resources :users, only: :index do
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
  end

  resources :credit_cards, only: %i[index create destroy]
  resources :stripe_accounts, only: %i[new create]

  resources :cookoons, only: %i[new create update] do
    resources :availabilities, only: %i[index create update], shallow: true
  end

  resources :reservations, only: %i[index show new create update] do
    resources :cookoons, only: %i[index show] do
      resources :payments, only: [] do
        post :amounts, on: :collection
      end
    end
    resources :chefs, only: :index
    resources :payments, only: %i[new create]
    patch 'cookoons/:id', to: 'cookoons#select_cookoon'
    patch 'menus/:id', to: 'cookoons#select_menu', as: :select_menu
    patch :ask_quotation, on: :member
    resources :invoices, only: :create
    resource :services, only: %i[index show create]
    resources :messages, controller: 'reservations/messages', only: %i[new create]
  end

  resources :services, only: [:destroy] do
    resources :payments, controller: 'services/payments', only: :create
  end

  # -------- HOST NAMESPACE ---------
  namespace :host do
    get :dashboard, to: 'users#dashboard'
    resources :reservations, only: %i[index edit update] do
      resources :inventories, only: %i[new create edit update], shallow: true
    end
  end

  # -------- ADMIN ROUTES ---------
  # Sidekiq Web UI, only for admins
  authenticate :user, ->(user) { user.admin } do
    mount Sidekiq::Web, at: :sidekiq
  end

  # ForestAdmin
  namespace :forest do
    # User
    post '/actions/award-invitations', to: 'users#award_invitations'
    post '/actions/change-e-mailing-preferences', to: 'users#change_emailing_preferences'

    # Reservation
    post '/actions/cancel-by-host', to: 'reservations#cancel_by_host'

    # Service
    post '/actions/create-service', to: 'services#create'

    # Company
    post '/actions/invite-user', to: 'companies#invite_user'
  end

  mount ForestLiana::Engine, at: :forest
end
