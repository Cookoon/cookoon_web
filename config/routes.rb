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

  resources :cookoons, except: :destroy do
    resources :reservations, only: :create
    resources :availabilities, only: %i[index create update], shallow: true
  end

  resources :reservations, only: %i[index show update] do
    resources :payments, only: %i[new create] do
      post :amounts, on: :collection
    end
    resources :invoices, only: :create
    resource :services, only: %i[show create]
    resources :guests, controller: 'reservations/guests', only: %i[index create] do
      post :create_all, on: :collection
    end
    resources :messages, controller: 'reservations/messages', only: %i[new create]
  end

  resources :services, only: [:destroy] do
    resources :payments, controller: 'services/payments', only: :create do
      post :amounts, on: :collection
    end
  end

  resources :ephemerals, only: [:show] do
    resources :payments, controller: 'ephemerals/payments', only: :create do
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

    resources :reservations, only: %i[show update]
    namespace :reservations do
      resources :cookoons, only: :show
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
    post '/actions/grant-credit', to: 'users#grant_credit'

    # Reservation
    post '/actions/cancel-by-host', to: 'reservations#cancel_by_host'

    # Service
    post '/actions/create-service', to: 'services#create'

    # Pro::Quote
    post '/actions/create-draft-reservation' => 'pro/quotes#create_draft_reservation'
  end

  mount ForestLiana::Engine, at: :forest
end
