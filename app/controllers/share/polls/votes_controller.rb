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

        @question.broadcast_replace_later \
          target: [@question, :results],
          html: Share::Polls::Results.new(@poll, @question).call(view_context:),
          attributes: {method: :morph}

        if @vote.valid?
          respond_to do |format|
            format.html { redirect_to [:share, @poll], notice: "Thank you for voting!".emojoy }
            format.turbo_stream do
              flash.now[:notice] = "Thank you for voting!".emojoy
              render turbo_stream: [
                turbo_stream.prepend("flash", partial: "application/flash"),
                turbo_stream.replace(
                  @poll,
                  renderable: Share::Polls::PollComponent.new(@poll, completed: @poll.voted_all?(device_uuid: ensure_device_uuid))
                )
              ]
            end
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
    end
  end
end
