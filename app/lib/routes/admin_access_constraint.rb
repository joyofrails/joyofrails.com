module Routes
  class AdminAccessConstraint
    def matches?(request)
      Rails.env.local? || request.env["warden"].authenticate?(scope: :admin_user)
    end
  end
end
