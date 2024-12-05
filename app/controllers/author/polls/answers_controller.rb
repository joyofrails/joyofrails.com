module Author
  module Polls
    class AnswersController < ApplicationController
      before_action :feature_enabled!
      before_action :authenticate_user!

      def new
        @poll = Current.user.polls.find(params[:poll_id])
        @question = @poll.questions.find(params[:question_id])
        @answer = @question.answers.build
      end

      def create
        @poll = Current.user.polls.find(params[:poll_id])
        @question = @poll.questions.find(params[:question_id])
        @answer = @question.answers.build(answer_params)

        if @answer.save
          respond_to do |format|
            format.html { redirect_to author_poll_path(@poll), notice: "Answer was successfully created." }
            format.turbo_stream { flash.now[:notice] = "Answer was successfully created." }
          end
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        @poll = Current.user.polls.find(params[:poll_id])
        @answer = @poll.answers.find(params[:id])
      end

      def update
        @poll = Current.user.polls.find(params[:poll_id])
        @answer = @poll.answers.find(params[:id])
        if @answer.update(answer_params)
          respond_to do |format|
            format.html { redirect_to author_poll_path(@poll), notice: "Answer was successfully updated." }
            format.turbo_stream { flash.now[:notice] = "Answer was successfully updated." }
          end
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @poll = Current.user.polls.find(params[:poll_id])
        @answer = @poll.answers.find(params[:id])
        @answer.destroy

        respond_to do |format|
          format.html { redirect_to author_poll_path(@poll), notice: "Answer was successfully destroyed." }
          format.turbo_stream { flash.now[:notice] = "Answer was successfully destroyed." }
        end
      end

      private

      def answer_params
        params.require(:answer).permit(:body)
      end

      def set_answer
        @answer = @question.answers.find(params[:id])
      end

      def feature_enabled!
        return if user_signed_in? &&
          Flipper.enabled?(:polls, Current.user)

        raise ActionController::RoutingError.new("Not Found")
      end
    end
  end
end
