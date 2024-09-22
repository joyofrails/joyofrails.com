require "rails/application_controller"

class Rails::PwaController < Rails::ApplicationController # :nodoc:
  include ColorScheming

  before_action :ensure_current_color_scheme, only: %i[manifest]

  skip_forgery_protection

  def serviceworker
    render template: "pwa/serviceworker", layout: false
  end

  def manifest
    render template: "pwa/manifest", content_type: "application/manifest+json", layout: false
  end
end
