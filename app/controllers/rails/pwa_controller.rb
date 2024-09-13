require "rails/application_controller"

class Rails::PwaController < Rails::ApplicationController # :nodoc:
  include ColorScheming

  before_action :ensure_current_color_scheme

  skip_forgery_protection

  def serviceworker
    render template: "pwa/serviceworker", layout: false
  end

  def manifest
    render template: "pwa/manifest", layout: false
  end
end
