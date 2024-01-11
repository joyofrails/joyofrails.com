module Routes
  class AdminAccessConstraint
    def matches?(request)
      request.env["warden"].authenticate?(scope: :admin_user)
    end
  end
end
