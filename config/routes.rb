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
  root 'pages#home'

  controller :pages do
    get :home
    get :support
    get :general_conditions
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

  resources :credit_cards, only: %i[index create destroy] do
    collection do
      get 'secret', to: 'credit_cards#secret'
    end
  end
  resources :stripe_accounts, only: %i[new create]

  resources :cookoons, only: %i[new create update] do
    resources :availabilities, only: %i[index create update], shallow: true
  end

  resources :reservations, only: %i[index show new create update] do
    resources :cookoons, only: %i[index show] do
      resources :payments, only: [] do
        post :amounts, on: :collection
      end
      patch :select_cookoon, to: 'reservations#select_cookoon', as: :select_cookoon
    end

    resources :chefs, only: %i[index show]

    resources :payments, only: %i[new create] do
      collection do
        get 'secret', to: 'payments#secret'
        get 'secret_services', to: 'payments#secret_services'
      end
    end
    patch 'menus/:id', to: 'reservations#select_menu', as: :select_menu
    # patch :reset_menu, on: :member
    patch :cooking_by_user, on: :member
    # patch :reset_cooking_by_user, on: :member
    patch :ask_quotation, on: :member
    patch :select_services, on: :member
    resources :invoices, only: :create
    # resources :services, only: %i[index show create]
    resources :services, only: %i[index]
    resources :messages, controller: 'reservations/messages', only: %i[new create]
  end

  # resources :services, only: [:destroy] do
  #   resources :payments, controller: 'services/payments', only: :create
  # end

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
    namespace :admin do
      controller :pages do
        get :dashboard
      end
      resources :perk_specifications, only: %i[index new create destroy]
      resources :cookoons, only: %i[index show new create edit update] do
        resources :perks, only: %i[new create destroy]
      end
      resources :chef_perk_specifications, only: %i[index new create destroy]
      resources :chefs, only: %i[index show new create edit update] do
        resources :chef_perks, only: %i[new create destroy]
        resources :menus, only: %i[new create edit update show] do
          resources :dishes, only: %i[create destroy]
        end
        patch 'menus/:id/validate_menu', to: 'menus#validate_menu', as: :validate_menu
        patch 'menus/:id/archive_menu', to: 'menus#archive_menu', as: :archive_menu
      end
      resources :reservations, only: %i[index show]
      patch 'reservations/:id', to: 'reservations#require_payment_for_menu', as: :require_payment_for_menu
    end
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
