module PollsHelper
  def voted_on?(poll)
    scope = poll.votes

    if user_signed_in?
      scope.where!(user: current_user)
    else
      scope.where!(device_uuid: cookies.signed[:device_uuid])
    end

    scope.count > 0
  end
end
