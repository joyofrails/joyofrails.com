require_relative "../app/lib/routes/admin_access_constraint"

# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # Redirects www to root domain
  match "(*any)", to: redirect(subdomain: ""), via: :all, constraints: {subdomain: "www"}

  resources :examples, only: [:index, :show]
  namespace :examples do
    resource :hello, only: [:show]
  end

  sitepress_pages

  # Defines the root path route ("/")
  sitepress_root

  namespace :pwa do
    resource :installation_instructions, only: [:show]
    resources :web_pushes, only: [:create]
  end

  # Render dynamic PWA files from app/views/pwa/*
  get "serviceworker" => "rails/pwa#serviceworker", :as => :pwa_serviceworker, :constraints => {format: "js"}
  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest, :constraints => {format: "json"}

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  namespace :users do
    resource :header_navigation, only: [:show]
  end

  namespace :admin_users do
    resources :sessions, only: [:new, :create] do
      collection do
        delete "sign_out" => "sessions#destroy", :as => "destroy"
      end
    end
  end

  unless Rails.env.wasm?
    scope :admin, constraints: Routes::AdminAccessConstraint.new do
      mount Flipper::UI.app(Flipper) => "/flipper"
      mount MissionControl::Jobs::Engine, at: "/jobs"
    end
  end
end
