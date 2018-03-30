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
  authenticated { root 'cookoons#index' }
  root 'pages#home'

  controller :pages do
    get :support
    get :setcookies
  end

  # -------- RESOURCES ---------
  resource :users, only: %i[edit update]
  resources :users, only: :index do
    post :impersonate, on: :member
    post :stop_impersonating, on: :collection
  end

  resources :user_searches, only: :create do
    patch :update_all, on: :collection
  end

  resources :credit_cards, only: %i[index create destroy]
  resources :stripe_accounts, only: %i[new create]

  resources :cookoons, except: :destroy do
    resources :reservations, only: :create
    resources :availabilities, only: %i[index create update], shallow: true
  end

  resources :reservations, only: %i[index show edit update] do
    resources :payments, only: %i[new create] do
      post :discount, on: :new
    end
    resources :invoices, only: :create
    resource :services, only: :show
    resources :guests, controller: 'reservations/guests', only: %i[index create] do
      post :create_all, on: :collection
    end
  end

  resources :services, only: [] do
    post :payments, to: 'services/payments#create'
    post :discount, to: 'services/payments#discount'
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
  mount ForestLiana::Engine, at: :forest

  namespace :forest do
    # User
    post '/actions/award-invitations', to: 'users#award_invitations'
    post '/actions/change-e-mailing-preferences', to: 'users#change_emailing_preferences'
    post '/actions/grant-credit', to: 'users#grant_credit'

    # Reservation
    post '/actions/cancel-by-host', to: 'reservations#cancel_by_host'

    # Service
    post '/actions/create-service', to: 'services#create'
  end
end
