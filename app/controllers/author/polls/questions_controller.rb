module Author
  module Polls
    class QuestionsController < ApplicationController
      def new
        @poll = current_user.polls.find(params[:poll_id])
        @question = @poll.questions.build
      end

      def create
        @poll = current_user.polls.find(params[:poll_id])
        @question = @poll.questions.build(question_params)

        if @question.save
          respond_to do |format|
            format.html { redirect_to author_poll_path(@poll), notice: "Date was successfully created." }
            format.turbo_stream { flash.now[:notice] = "Date was successfully created." }
          end
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        @poll = current_user.polls.find(params[:poll_id])
        @question = @poll.questions.find(params[:id])
      end

      def update
        @poll = current_user.polls.find(params[:poll_id])
        @question = @poll.questions.find(params[:id])
        if @question.update(question_params)
          respond_to do |format|
            format.html { redirect_to author_poll_path(@poll), notice: "Date was successfully updated." }
            format.turbo_stream { flash.now[:notice] = "Date was successfully updated." }
          end
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        @poll = current_user.polls.find(params[:poll_id])
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

      def set_question
        @question = @poll.questions.find(params[:id])
      end
    end
  end
end
