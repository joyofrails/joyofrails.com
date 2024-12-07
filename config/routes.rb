# == Route Map
#
#                                     Prefix Verb            URI Pattern                                                                                       Controller#Action
#                                                            /assets                                                                                           Propshaft::Server
#                                                            /(*any)(.:format)                                                                                 redirect(301, subdomain: ) {:subdomain=>"www"}
#                                       root GET             /                                                                                                 site#show
#                                       page GET             /*resource_path                                                                                   site#show
#                                     search GET|POST        /search(.:format)                                                                                 searches#show
#                                     topics GET             /topics(.:format)                                                                                 topics#index
#                                      topic GET             /topics/:slug(.:format)                                                                           topics#show
#                           share_poll_votes POST            /share/polls/:poll_id/votes(.:format)                                                             share/polls/votes#create
#                                share_polls GET             /share/polls(.:format)                                                                            share/polls#index
#                                 share_poll GET             /share/polls/:id(.:format)                                                                        share/polls#show
#               new_share_snippet_screenshot GET             /share/snippets/:snippet_id/screenshot/new(.:format)                                              share/snippet_screenshots#new
#                   share_snippet_screenshot GET             /share/snippets/:snippet_id/screenshot(.:format)                                                  share/snippet_screenshots#show
#                                            POST            /share/snippets/:snippet_id/screenshot(.:format)                                                  share/snippet_screenshots#create
#                    new_share_snippet_tweet GET             /share/snippets/:snippet_id/tweet/new(.:format)                                                   share/snippet_tweets#new
#                             share_snippets GET             /share/snippets(.:format)                                                                         share/snippets#index
#                                            POST            /share/snippets(.:format)                                                                         share/snippets#create
#                          new_share_snippet GET             /share/snippets/new(.:format)                                                                     share/snippets#new
#                         edit_share_snippet GET             /share/snippets/:id/edit(.:format)                                                                share/snippets#edit
#                              share_snippet GET             /share/snippets/:id(.:format)                                                                     share/snippets#show
#                                            PATCH           /share/snippets/:id(.:format)                                                                     share/snippets#update
#                                            PUT             /share/snippets/:id(.:format)                                                                     share/snippets#update
#                                            DELETE          /share/snippets/:id(.:format)                                                                     share/snippets#destroy
#                            author_snippets GET             /author/snippets(.:format)                                                                        author/snippets#index
#                                            POST            /author/snippets(.:format)                                                                        author/snippets#create
#                         new_author_snippet GET             /author/snippets/new(.:format)                                                                    author/snippets#new
#                        edit_author_snippet GET             /author/snippets/:id/edit(.:format)                                                               author/snippets#edit
#                             author_snippet GET             /author/snippets/:id(.:format)                                                                    author/snippets#show
#                                            PATCH           /author/snippets/:id(.:format)                                                                    author/snippets#update
#                                            PUT             /author/snippets/:id(.:format)                                                                    author/snippets#update
#                                            DELETE          /author/snippets/:id(.:format)                                                                    author/snippets#destroy
#               author_poll_question_answers POST            /author/polls/:poll_id/questions/:question_id/answers(.:format)                                   author/polls/answers#create
#            new_author_poll_question_answer GET             /author/polls/:poll_id/questions/:question_id/answers/new(.:format)                               author/polls/answers#new
#                      author_poll_questions POST            /author/polls/:poll_id/questions(.:format)                                                        author/polls/questions#create
#                   new_author_poll_question GET             /author/polls/:poll_id/questions/new(.:format)                                                    author/polls/questions#new
#                  edit_author_poll_question GET             /author/polls/:poll_id/questions/:id/edit(.:format)                                               author/polls/questions#edit
#                       author_poll_question PATCH           /author/polls/:poll_id/questions/:id(.:format)                                                    author/polls/questions#update
#                                            PUT             /author/polls/:poll_id/questions/:id(.:format)                                                    author/polls/questions#update
#                                            DELETE          /author/polls/:poll_id/questions/:id(.:format)                                                    author/polls/questions#destroy
#                    edit_author_poll_answer GET             /author/polls/:poll_id/answers/:id/edit(.:format)                                                 author/polls/answers#edit
#                         author_poll_answer PATCH           /author/polls/:poll_id/answers/:id(.:format)                                                      author/polls/answers#update
#                                            PUT             /author/polls/:poll_id/answers/:id(.:format)                                                      author/polls/answers#update
#                                            DELETE          /author/polls/:poll_id/answers/:id(.:format)                                                      author/polls/answers#destroy
#                               author_polls GET             /author/polls(.:format)                                                                           author/polls#index
#                                            POST            /author/polls(.:format)                                                                           author/polls#create
#                            new_author_poll GET             /author/polls/new(.:format)                                                                       author/polls#new
#                           edit_author_poll GET             /author/polls/:id/edit(.:format)                                                                  author/polls#edit
#                                author_poll GET             /author/polls/:id(.:format)                                                                       author/polls#show
#                                            PATCH           /author/polls/:id(.:format)                                                                       author/polls#update
#                                            PUT             /author/polls/:id(.:format)                                                                       author/polls#update
#                                            DELETE          /author/polls/:id(.:format)                                                                       author/polls#destroy
#                                newsletters GET             /newsletters(.:format)                                                                            newsletters#index
#                                 newsletter GET             /newsletters/:id(.:format)                                                                        newsletters#show
#                          examples_counters GET             /examples/counters(.:format)                                                                      examples/counters#show
#                                            PATCH           /examples/counters(.:format)                                                                      examples/counters#update
#                                            PUT             /examples/counters(.:format)                                                                      examples/counters#update
#                                            DELETE          /examples/counters(.:format)                                                                      examples/counters#destroy
#                             examples_hello GET             /examples/hello(.:format)                                                                         examples/hellos#show
#                             examples_posts GET             /examples/posts(.:format)                                                                         examples/posts#index
#                                            POST            /examples/posts(.:format)                                                                         examples/posts#create
#                          new_examples_post GET             /examples/posts/new(.:format)                                                                     examples/posts#new
#                                   examples GET             /examples(.:format)                                                                               examples#index
#                                    example GET             /examples/:id(.:format)                                                                           examples#show
#                                 feed_index GET             /feed(.:format)                                                                                   feed#index {:format=>/atom/}
#                              color_schemes GET             /color_schemes(.:format)                                                                          color_schemes#index
#                               color_scheme GET             /color_schemes/:id(.:format)                                                                      color_schemes#show
#              preview_settings_color_scheme GET             /settings/color_scheme/preview(.:format)                                                          settings/color_schemes#preview
#                      settings_color_scheme GET             /settings/color_scheme(.:format)                                                                  settings/color_schemes#show
#                                            PATCH           /settings/color_scheme(.:format)                                                                  settings/color_schemes#update
#                                            PUT             /settings/color_scheme(.:format)                                                                  settings/color_schemes#update
#                  settings_syntax_highlight GET             /settings/syntax_highlight(.:format)                                                              settings/syntax_highlights#show
#                                            PATCH           /settings/syntax_highlight(.:format)                                                              settings/syntax_highlights#update
#                                            PUT             /settings/syntax_highlight(.:format)                                                              settings/syntax_highlights#update
#              pwa_installation_instructions GET             /pwa/installation_instructions(.:format)                                                          pwa/installation_instructions#show
#                             pwa_web_pushes POST            /pwa/web_pushes(.:format)                                                                         pwa/web_pushes#create
#                            users_thank_you GET             /users/thank_you(.:format)                                                                        users/thank_yous#show
#                    users_header_navigation GET             /users/header_navigation(.:format)                                                                users/header_navigations#show
#                     new_users_registration GET             /users/registration/new(.:format)                                                                 users/registrations#new
#                    edit_users_registration GET             /users/registration/edit(.:format)                                                                users/registrations#edit
#                         users_registration PATCH           /users/registration(.:format)                                                                     users/registrations#update
#                                            PUT             /users/registration(.:format)                                                                     users/registrations#update
#                                            DELETE          /users/registration(.:format)                                                                     users/registrations#destroy
#                                            POST            /users/registration(.:format)                                                                     users/registrations#create
#                 confirm_users_confirmation GET             /users/confirmations/:token/confirm(.:format)                                                     users/confirmations#update
#                        users_confirmations POST            /users/confirmations(.:format)                                                                    users/confirmations#create
#                     new_users_confirmation GET             /users/confirmations/new(.:format)                                                                users/confirmations#new
#                    edit_users_confirmation GET             /users/confirmations/:token/edit(.:format)                                                        users/confirmations#edit
#                         users_confirmation PATCH           /users/confirmations/:token(.:format)                                                             users/confirmations#update
#                                            PUT             /users/confirmations/:token(.:format)                                                             users/confirmations#update
#                            users_passwords POST            /users/passwords(.:format)                                                                        users/passwords#create
#                         new_users_password GET             /users/passwords/new(.:format)                                                                    users/passwords#new
#                        edit_users_password GET             /users/passwords/:token/edit(.:format)                                                            users/passwords#edit
#                             users_password PATCH           /users/passwords/:token(.:format)                                                                 users/passwords#update
#                                            PUT             /users/passwords/:token(.:format)                                                                 users/passwords#update
#   subscribe_users_newsletter_subscriptions POST            /users/newsletter_subscriptions/subscribe(.:format)                                               users/newsletter_subscriptions#subscribe
#             users_newsletter_subscriptions GET             /users/newsletter_subscriptions(.:format)                                                         users/newsletter_subscriptions#index
#                                            POST            /users/newsletter_subscriptions(.:format)                                                         users/newsletter_subscriptions#create
#          new_users_newsletter_subscription GET             /users/newsletter_subscriptions/new(.:format)                                                     users/newsletter_subscriptions#new
#              users_newsletter_subscription GET             /users/newsletter_subscriptions/:id(.:format)                                                     users/newsletter_subscriptions#show
# unsubscribe_users_newsletter_subscriptions GET|POST|DELETE /users/newsletter_subscriptions/unsubscribe(.:format)                                             users/newsletter_subscriptions#unsubscribe
#  unsubscribe_users_newsletter_subscription GET|POST|DELETE /users/newsletter_subscriptions/:token/unsubscribe(.:format)                                      users/newsletter_subscriptions#unsubscribe
#                 users_magic_session_tokens POST            /users/magic_session_tokens(.:format)                                                             users/magic_session_tokens#create
#              new_users_magic_session_token GET             /users/magic_session_tokens/new(.:format)                                                         users/magic_session_tokens#new
#                  users_magic_session_token GET             /users/magic_session_tokens/:token(.:format)                                                      users/magic_session_tokens#show
#                     destroy_users_sessions DELETE          /users/sessions/sign_out(.:format)                                                                users/sessions#destroy
#                             users_sessions POST            /users/sessions(.:format)                                                                         users/sessions#create
#                          new_users_session GET             /users/sessions/new(.:format)                                                                     users/sessions#new
#               destroy_admin_users_sessions DELETE          /admin_users/sessions/sign_out(.:format)                                                          admin_users/sessions#destroy
#                       admin_users_sessions POST            /admin_users/sessions(.:format)                                                                   admin_users/sessions#create
#                    new_admin_users_session GET             /admin_users/sessions/new(.:format)                                                               admin_users/sessions#new
#                            users_dashboard GET             /users/dashboard(.:format)                                                                        users/dashboard#index
#                                 admin_root GET             /admin(.:format)                                                                                  admin/home#index
#                   deliver_admin_newsletter PATCH           /admin/newsletters/:id/deliver(.:format)                                                          admin/newsletters#deliver
#                          admin_newsletters GET             /admin/newsletters(.:format)                                                                      admin/newsletters#index
#                                            POST            /admin/newsletters(.:format)                                                                      admin/newsletters#create
#                       new_admin_newsletter GET             /admin/newsletters/new(.:format)                                                                  admin/newsletters#new
#                      edit_admin_newsletter GET             /admin/newsletters/:id/edit(.:format)                                                             admin/newsletters#edit
#                           admin_newsletter GET             /admin/newsletters/:id(.:format)                                                                  admin/newsletters#show
#                                            PATCH           /admin/newsletters/:id(.:format)                                                                  admin/newsletters#update
#                                            PUT             /admin/newsletters/:id(.:format)                                                                  admin/newsletters#update
#                                            DELETE          /admin/newsletters/:id(.:format)                                                                  admin/newsletters#destroy
#                                                            /admin/flipper                                                                                    Flipper::UI
#                 admin_mission_control_jobs                 /admin/jobs                                                                                       MissionControl::Jobs::Engine
#                           admin_litestream                 /admin/litestream                                                                                 Litestream::Engine
#                                rails_admin                 /admin/data                                                                                       RailsAdmin::Engine
#                                            GET             /404(.:format)                                                                                    errors#not_found
#                                            GET             /500(.:format)                                                                                    errors#internal_server
#                                            GET             /422(.:format)                                                                                    errors#unprocessable
#                          pwa_serviceworker GET             /serviceworker(.:format)                                                                          rails/pwa#serviceworker {:format=>"js"}
#                               pwa_manifest GET             /manifest(.:format)                                                                               rails/pwa#manifest {:format=>"json"}
#                         rails_health_check GET             /up(.:format)                                                                                     rails/health#show
#           turbo_recede_historical_location GET             /recede_historical_location(.:format)                                                             turbo/native/navigation#recede
#           turbo_resume_historical_location GET             /resume_historical_location(.:format)                                                             turbo/native/navigation#resume
#          turbo_refresh_historical_location GET             /refresh_historical_location(.:format)                                                            turbo/native/navigation#refresh
#              rails_postmark_inbound_emails POST            /rails/action_mailbox/postmark/inbound_emails(.:format)                                           action_mailbox/ingresses/postmark/inbound_emails#create
#                 rails_relay_inbound_emails POST            /rails/action_mailbox/relay/inbound_emails(.:format)                                              action_mailbox/ingresses/relay/inbound_emails#create
#              rails_sendgrid_inbound_emails POST            /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                           action_mailbox/ingresses/sendgrid/inbound_emails#create
#        rails_mandrill_inbound_health_check GET             /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#health_check
#              rails_mandrill_inbound_emails POST            /rails/action_mailbox/mandrill/inbound_emails(.:format)                                           action_mailbox/ingresses/mandrill/inbound_emails#create
#               rails_mailgun_inbound_emails POST            /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                                       action_mailbox/ingresses/mailgun/inbound_emails#create
#             rails_conductor_inbound_emails GET             /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#index
#                                            POST            /rails/conductor/action_mailbox/inbound_emails(.:format)                                          rails/conductor/action_mailbox/inbound_emails#create
#          new_rails_conductor_inbound_email GET             /rails/conductor/action_mailbox/inbound_emails/new(.:format)                                      rails/conductor/action_mailbox/inbound_emails#new
#              rails_conductor_inbound_email GET             /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                                      rails/conductor/action_mailbox/inbound_emails#show
#   new_rails_conductor_inbound_email_source GET             /rails/conductor/action_mailbox/inbound_emails/sources/new(.:format)                              rails/conductor/action_mailbox/inbound_emails/sources#new
#      rails_conductor_inbound_email_sources POST            /rails/conductor/action_mailbox/inbound_emails/sources(.:format)                                  rails/conductor/action_mailbox/inbound_emails/sources#create
#      rails_conductor_inbound_email_reroute POST            /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                               rails/conductor/action_mailbox/reroutes#create
#   rails_conductor_inbound_email_incinerate POST            /rails/conductor/action_mailbox/:inbound_email_id/incinerate(.:format)                            rails/conductor/action_mailbox/incinerates#create
#                         rails_service_blob GET             /rails/active_storage/blobs/redirect/:signed_id/*filename(.:format)                               active_storage/blobs/redirect#show
#                   rails_service_blob_proxy GET             /rails/active_storage/blobs/proxy/:signed_id/*filename(.:format)                                  active_storage/blobs/proxy#show
#                                            GET             /rails/active_storage/blobs/:signed_id/*filename(.:format)                                        active_storage/blobs/redirect#show
#                  rails_blob_representation GET             /rails/active_storage/representations/redirect/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations/redirect#show
#            rails_blob_representation_proxy GET             /rails/active_storage/representations/proxy/:signed_blob_id/:variation_key/*filename(.:format)    active_storage/representations/proxy#show
#                                            GET             /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)          active_storage/representations/redirect#show
#                         rails_disk_service GET             /rails/active_storage/disk/:encoded_key/*filename(.:format)                                       active_storage/disk#show
#                  update_rails_disk_service PUT             /rails/active_storage/disk/:encoded_token(.:format)                                               active_storage/disk#update
#                       rails_direct_uploads POST            /rails/active_storage/direct_uploads(.:format)                                                    active_storage/direct_uploads#create
#
# Routes for MissionControl::Jobs::Engine:
#     application_queue_pause DELETE /applications/:application_id/queues/:queue_id/pause(.:format) mission_control/jobs/queues/pauses#destroy
#                             POST   /applications/:application_id/queues/:queue_id/pause(.:format) mission_control/jobs/queues/pauses#create
#          application_queues GET    /applications/:application_id/queues(.:format)                 mission_control/jobs/queues#index
#           application_queue GET    /applications/:application_id/queues/:id(.:format)             mission_control/jobs/queues#show
#       application_job_retry POST   /applications/:application_id/jobs/:job_id/retry(.:format)     mission_control/jobs/retries#create
#     application_job_discard POST   /applications/:application_id/jobs/:job_id/discard(.:format)   mission_control/jobs/discards#create
#    application_job_dispatch POST   /applications/:application_id/jobs/:job_id/dispatch(.:format)  mission_control/jobs/dispatches#create
#    application_bulk_retries POST   /applications/:application_id/jobs/bulk_retries(.:format)      mission_control/jobs/bulk_retries#create
#   application_bulk_discards POST   /applications/:application_id/jobs/bulk_discards(.:format)     mission_control/jobs/bulk_discards#create
#             application_job GET    /applications/:application_id/jobs/:id(.:format)               mission_control/jobs/jobs#show
#            application_jobs GET    /applications/:application_id/:status/jobs(.:format)           mission_control/jobs/jobs#index
#         application_workers GET    /applications/:application_id/workers(.:format)                mission_control/jobs/workers#index
#          application_worker GET    /applications/:application_id/workers/:id(.:format)            mission_control/jobs/workers#show
# application_recurring_tasks GET    /applications/:application_id/recurring_tasks(.:format)        mission_control/jobs/recurring_tasks#index
#  application_recurring_task GET    /applications/:application_id/recurring_tasks/:id(.:format)    mission_control/jobs/recurring_tasks#show
#                             PATCH  /applications/:application_id/recurring_tasks/:id(.:format)    mission_control/jobs/recurring_tasks#update
#                             PUT    /applications/:application_id/recurring_tasks/:id(.:format)    mission_control/jobs/recurring_tasks#update
#                      queues GET    /queues(.:format)                                              mission_control/jobs/queues#index
#                       queue GET    /queues/:id(.:format)                                          mission_control/jobs/queues#show
#                         job GET    /jobs/:id(.:format)                                            mission_control/jobs/jobs#show
#                        jobs GET    /:status/jobs(.:format)                                        mission_control/jobs/jobs#index
#                        root GET    /                                                              mission_control/jobs/queues#index
#
# Routes for Litestream::Engine:
#         root GET  /                       litestream/processes#show
#      process GET  /                       litestream/processes#show
# restorations POST /restorations(.:format) litestream/restorations#create
#
# Routes for RailsAdmin::Engine:
#   dashboard GET         /                                      rails_admin/main#dashboard
#       index GET|POST    /:model_name(.:format)                 rails_admin/main#index
#         new GET|POST    /:model_name/new(.:format)             rails_admin/main#new
#      export GET|POST    /:model_name/export(.:format)          rails_admin/main#export
# bulk_delete POST|DELETE /:model_name/bulk_delete(.:format)     rails_admin/main#bulk_delete
# bulk_action POST        /:model_name/bulk_action(.:format)     rails_admin/main#bulk_action
#        show GET         /:model_name/:id(.:format)             rails_admin/main#show
#        edit GET|PUT     /:model_name/:id/edit(.:format)        rails_admin/main#edit
#      delete GET|DELETE  /:model_name/:id/delete(.:format)      rails_admin/main#delete
# show_in_app GET         /:model_name/:id/show_in_app(.:format) rails_admin/main#show_in_app

require_relative "../app/lib/routes/admin_access_constraint"
require_relative "../app/lib/routes/users_access_constraint"

# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  # Redirects www to root domain
  match "(*any)", to: redirect(subdomain: ""), via: :all, constraints: {subdomain: "www"}

  # Defines the root path route ("/")
  sitepress_root controller: :site
  sitepress_pages controller: :site

  match "search", to: "searches#show", via: [:get, :post]

  resources :topics, param: :slug, only: [:index, :show]

  namespace :share do
    resources :polls, only: [:index, :show] do
      resources :votes, only: [:create], controller: "polls/votes"
    end

    resources :snippets do
      resource :screenshot, only: [:new, :create, :show], controller: "snippet_screenshots"
      resource :tweet, only: [:new], controller: "snippet_tweets"
    end
  end

  namespace :author do
    resources :snippets

    resources :polls do
      resources :questions, only: [:new, :create, :edit, :update, :destroy], controller: "polls/questions" do
        resources :answers, only: [:new, :create], controller: "polls/answers"
      end

      resources :answers, only: [:edit, :update, :destroy], controller: "polls/answers"
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
