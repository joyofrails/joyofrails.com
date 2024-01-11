require "litestack/liteboard/liteboard"

require_relative "../app/lib/routes/admin_access_constraint"

# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # Redirects www to root domain
  match "(*any)", to: redirect(subdomain: ""), via: :all, constraints: {subdomain: "www"}

  sitepress_pages

  # Defines the root path route ("/")
  sitepress_root

  namespace :admin_users do
    resources :sessions, only: [:new, :create] do
      collection do
        delete "sign_out" => "sessions#destroy", :as => "destroy"
      end
    end
  end

  namespace :pwa do
    resource :installation_instructions, only: [:show]
  end

  scope :admin, constraints: Routes::AdminAccessConstraint.new do
    mount Liteboard.app => "/liteboard"
    mount Flipper::UI.app(Flipper) => "/flipper"
  end

  # Render dynamic PWA files from app/views/pwa/*
  get "serviceworker" => "pwa#serviceworker", :as => :pwa_serviceworker
  get "manifest" => "pwa#manifest", :as => :pwa_manifest

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check
end
