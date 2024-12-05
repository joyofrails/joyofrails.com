module Share
  module Polls
    class VotesController < ApplicationController
      using Refinements::Emojoy

      def create
        @poll = Poll.find(params[:poll_id])
        @answer = @poll.answers.includes(:question).find(params[:answer_id])
        @question = @answer.question
        @vote = @question.votes.find_by(device_uuid: ensure_device_uuid)
        @vote ||= record_vote(@answer)

        if @vote.valid?
          flash[:notice] = "Thank you for voting!".emojoy
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

      def record_vote(answer)
        answer.votes.create(device_uuid: ensure_device_uuid) do |vote|
          vote.user = Current.user if user_signed_in?
        end
      end

      def ensure_device_uuid
        cookies.signed[:device_uuid] ||= SecureRandom.uuid_v7
      end
    end
  end
end
