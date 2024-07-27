class ApplicationController < ActionController::Base
  include Erroring
  include Authentication
  include ColorScheming
  include SyntaxHighlighting
end
