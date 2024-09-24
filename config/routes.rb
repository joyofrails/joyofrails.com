require_relative "../app/lib/routes/admin_access_constraint"
require_relative "../app/lib/routes/users_access_constraint"

# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # Redirects www to root domain
  match "(*any)", to: redirect(subdomain: ""), via: :all, constraints: {subdomain: "www"}

  # Defines the root path route ("/")
  sitepress_root controller: :site
  sitepress_pages controller: :site

  namespace :share do
    resources :snippets do
      resource :screenshot, only: [:new, :create, :show], controller: "snippet_screenshots"
      resource :tweet, only: [:new], controller: "snippet_tweets"
    end
  end

  resources :newsletters, only: [:index, :show]

  namespace :examples do
    resource :counters, only: [:show, :update, :destroy]
    resource :hello, only: [:show]
    resources :posts, only: [:index, :create, :new]
  end
  resources :examples, only: [:index, :show]

  resources :feed, only: [:index], format: "atom"

  resources :color_schemes, only: [:index, :show]

  namespace :settings do
    resource :color_scheme, only: [:show, :update] do
      member do
        get :preview
      end
    end
    resource :syntax_highlight, only: [:show, :update]
  end

  namespace :pwa do
    resource :installation_instructions, only: [:show]
    resources :web_pushes, only: [:create]
  end

  namespace :users do
    resource :thank_you, only: [:show]
    resource :header_navigation, only: [:show]
    resource :registration, only: [:new, :create, :edit, :update, :destroy]
    resources :confirmations, only: [:new, :create, :edit, :update], param: :token do
      member do
        match "confirm" => "confirmations#update", :via => [:get]
      end
    end
    resources :passwords, only: [:new, :create, :edit, :update], param: :token

    resources :newsletter_subscriptions, only: [:new, :create, :index, :show] do
      collection do
        post :subscribe
      end
    end

    resources :newsletter_subscriptions, only: [], param: :token do
      match :unsubscribe, on: :collection, via: [:get, :post, :delete]
      match :unsubscribe, on: :member, via: [:get, :post, :delete]
    end

    resources :magic_session_tokens, only: [:new, :create, :show], param: :token
    resources :sessions, only: [:new, :create] do
      collection do
        delete "sign_out" => "sessions#destroy", :as => :destroy
      end
    end
  end

  namespace :admin_users do
    resources :sessions, only: [:new, :create] do
      collection do
        delete "sign_out" => "sessions#destroy", :as => "destroy"
      end
    end
  end

  scope :users, constraints: Routes::UsersAccessConstraint.new do
    get "dashboard" => "users/dashboard#index", :as => :users_dashboard
  end

  namespace :admin, constraints: Routes::AdminAccessConstraint.new do
    root to: "home#index"

    resources :newsletters do
      member do
        patch :deliver
      end
    end

    mount Flipper::UI.app(Flipper) => "/flipper"
    mount MissionControl::Jobs::Engine, at: "/jobs"
    mount Litestream::Engine => "/litestream"
  end

  mount RailsAdmin::Engine => "/admin/data", :as => "rails_admin", :constraints => Routes::AdminAccessConstraint.new

  get "/404", to: "errors#not_found"
  get "/500", to: "errors#internal_server"
  get "/422", to: "errors#unprocessable"

  # Render dynamic PWA files from app/views/pwa/*
  get "serviceworker" => "rails/pwa#serviceworker", :as => :pwa_serviceworker, :constraints => {format: "js"}
  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest, :constraints => {format: "json"}

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check
end
