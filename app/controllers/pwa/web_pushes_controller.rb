class Pwa::WebPushesController < ApplicationController
  def create
    web_push_params = params.require(:web_push).permit(:message, :subscription)

    Pwa::WebPushJob.perform_later(
      message: web_push_params[:message],
      subscription: JSON.parse(web_push_params[:subscription])
    )

    head :ok
  end
end
