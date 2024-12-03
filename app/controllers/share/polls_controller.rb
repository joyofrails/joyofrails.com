class Share::PollsController < ApplicationController
  before_action :ensure_device_uuid, only: :show

  def index
    @polls = Poll.all
  end

  def show
    @poll = Poll.find(params[:id])
    @vote = @poll.votes.find_by(device_uuid: cookies.signed[:device_uuid])
  end

  private

  def ensure_device_uuid
    cookies.signed[:device_uuid] ||= SecureRandom.uuid_v7
  end

  def poll_params
    params.require(:poll).permit(:response)
  end
end
