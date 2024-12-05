class ApplicationController < ActionController::Base
  include Erroring

  include Authentication
  include ColorScheming
  include DeviceUuid
  include SyntaxHighlighting
end
