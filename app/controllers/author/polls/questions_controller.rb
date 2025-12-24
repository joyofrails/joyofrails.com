module Author
  module Polls
    class QuestionsController < ApplicationController
      before_action :feature_enabled!
      before_action :authenticate_user!

      def new
        @poll = Current.user.polls.find(params[:poll_id])
        @question = @poll.questions.build
      end

      def create
        @poll = Current.user.polls.find(params[:poll_id])
        @question = @poll.questions.build(question_params)

        if @question.save
          respond_to do |format|
            format.html { redirect_to author_poll_path(@poll), notice: "Date was successfully created." }
            format.turbo_stream { flash.now[:notice] = "Date was successfully created." }
          end
        else
          render :new, status: :unprocessable_content
        end
      end

      def edit
        @poll = Current.user.polls.find(params[:poll_id])
        @question = @poll.questions.find(params[:id])
      end

      def update
        @poll = Current.user.polls.find(params[:poll_id])
        @question = @poll.questions.find(params[:id])
        if @question.update(question_params)
          respond_to do |format|
            format.html { redirect_to author_poll_path(@poll), notice: "Date was successfully updated." }
            format.turbo_stream { flash.now[:notice] = "Date was successfully updated." }
          end
        else
          render :edit, status: :unprocessable_content
        end
      end

      def destroy
        @poll = Current.user.polls.find(params[:poll_id])
        @question = @poll.questions.find(params[:id])
        @question.destroy

        respond_to do |format|
          format.html { redirect_to author_poll_path(@poll), notice: "Date was successfully destroyed." }
          format.turbo_stream { flash.now[:notice] = "Date was successfully destroyed." }
        end
      end

      private

      def question_params
        params.require(:question).permit(:body)
      end

      def feature_enabled!
        return if user_signed_in? &&
          Flipper.enabled?(:polls, Current.user)

        raise ActionController::RoutingError.new("Not Found")
      end
    end
  end
end
