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

  resources :cookoon_searches, only: :create do
    patch :update_all, on: :collection
  end

  resources :credit_cards, only: %i[index create destroy]
  resources :stripe_accounts, only: %i[new create]

  resources :cookoons, only: %i[new create update] do
    resources :availabilities, only: %i[index create update], shallow: true
  end

  resources :reservations, only: %i[index show new create update] do
    resources :cookoons, only: %i[index show]
    patch 'cookoons/:id', to: 'cookoons#select_cookoon'
    resources :payments, only: %i[new create] do
      post :amounts, on: :collection
    end
    resources :invoices, only: :create
    resource :services, only: %i[index show create]
    resources :messages, controller: 'reservations/messages', only: %i[new create]
  end

  resources :services, only: [:destroy] do
    resources :payments, controller: 'services/payments', only: :create do
      post :amounts, on: :collection
    end
  end

  # -------- HOST NAMESPACE ---------
  namespace :host do
    get :dashboard, to: 'users#dashboard'
    resources :reservations, only: %i[index edit update] do
      resources :inventories, only: %i[new create edit update], shallow: true
    end
  end

  # -------- PRO NAMESPACE ---------
  namespace :pro do
    root 'pages#home'

    resources :quotes, only: %i[index create update] do
      resources :cookoons, only: %i[index show] do
        resources :quote_cookoons, only: %i[create]
      end
      resources :services, controller: 'quote_services',
                           only: %i[index create destroy update],
                           shallow: true
      get :request_confirmation
    end

    resources :reservations, only: %i[index show update]
    resource :user, only: %i[edit update]
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
    post '/actions/grant-credit', to: 'users#grant_credit'

    # Reservation
    post '/actions/cancel-by-host', to: 'reservations#cancel_by_host'

    # Service
    post '/actions/create-service', to: 'services#create'

    # Company
    post '/actions/invite-user', to: 'companies#invite_user'

    # Pro::Quote
    post '/actions/create-draft-reservation', to: 'pro/quotes#create_draft_reservation'

    # Pro::Reservation
    post '/actions/add-service-from-specification', to: 'pro/reservations#add_service_from_specification'
    post '/actions/propose-reservation', to: 'pro/reservations#propose_reservation'
    post '/actions/duplicate-reservation-as-draft', to: 'pro/reservations#duplicate_reservation_as_draft'
  end

  mount ForestLiana::Engine, at: :forest
end
