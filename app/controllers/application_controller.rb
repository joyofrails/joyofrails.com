class ApplicationController < ActionController::Base
  include Erroring
  include Authentication
  include ColorScheming
end
