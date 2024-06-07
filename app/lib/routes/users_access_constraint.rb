module Routes
  class UsersAccessConstraint
    def matches?(request)
      request.env["warden"].authenticate?(scope: :user)
    end
  end
end
