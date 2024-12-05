class Share::PollsController < ApplicationController
  before_action :ensure_device_uuid, only: :show

  def index
    @polls = Poll.all
  end

  def show
    @poll = Poll.find(params[:id])
  end

  private

  def ensure_device_uuid
    cookies.signed[:device_uuid] ||= SecureRandom.uuid_v7
  end

  helper_method :ensure_device_uuid

  def poll_params
    params.require(:poll).permit(:response)
  end
end
