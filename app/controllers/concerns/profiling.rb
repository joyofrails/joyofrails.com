module Profiling
  extend ActiveSupport::Concern

  included do
    before_action do
      if admin_user_signed_in?
        Rack::MiniProfiler.authorize_request
      end
    end
  end
end
