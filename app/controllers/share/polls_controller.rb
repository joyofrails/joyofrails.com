class Share::PollsController < ApplicationController
  before_action :ensure_device_uuid, only: :show

  def index
    @polls = Poll.all
  end

  def show
    @poll = Poll.find(params[:id])
  end

  private

  def poll_params
    params.require(:poll).permit(:response)
  end
end
