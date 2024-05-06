class ApplicationController < ActionController::Base
  include Authentication
  include Profiling
end
