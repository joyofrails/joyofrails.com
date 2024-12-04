module Share
  module Polls
    class VotesController < ApplicationController
      before_action :ensure_device_uuid

      def create
        @poll = Poll.find(params[:poll_id])
        @vote = @poll.votes.find_by(device_uuid: cookies.signed[:device_uuid])
        @vote ||= @poll.record_vote(
          answer_id: params[:answer_id],
          device_uuid: cookies.signed[:device_uuid],
          user: (current_user if user_signed_in?)
        )

        if @vote.valid?
          flash[:notice] = "Thank you for voting!"
          respond_to do |format|
            format.html { redirect_to [:share, @poll] }

            # Why is request_id set to nil?
            #
            # Credit: https://radanskoric.com/articles/update-full-page-on-form-in-frame-submit
            # "By default Turbo will ignore refreshes that result from requests
            # started from the current page. This is done to avoid double
            # refresh when we make a change which then broadcasts a refresh
            # through ActionCable. However, in this case this is exactly what
            # we want to do so we have to clear request id."
            format.turbo_stream { render turbo_stream: turbo_stream.refresh(request_id: nil) }
          end
        else
          render :new
        end
      end

      private

      def ensure_device_uuid
        cookies.signed[:device_uuid] ||= SecureRandom.uuid_v7
      end
    end
  end
end
