class ApplicationController < ActionController::Base
  include Erroring
  include Authentication
end
