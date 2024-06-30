module Erroring
  def not_found!
    raise ActionController::RoutingError, "Route not found #{request.path}"
  end
end
