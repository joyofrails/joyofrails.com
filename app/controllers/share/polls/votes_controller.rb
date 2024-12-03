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

        @poll.broadcast_replace_to @poll, :results, target: [@poll, :results], partial: "share/polls/results"

        if @vote.valid?
          respond_to do |format|
            format.html { redirect_to [:share, @poll], notice: "Thank you for voting!" }
            format.turbo_stream do
              flash.now[:notice] = "Thank you for voting!"
              render turbo_stream: [
                turbo_stream.prepend("flash", partial: "application/flash"),
                turbo_stream.replace(@poll, partial: "share/polls/poll", locals: {poll: @poll})
              ]
            end
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
