module Author
  class PollsController < ApplicationController
    using Refinements::Emojoy

    before_action :feature_enabled!
    before_action :authenticate_user!

    def index
      @polls = Current.user.polls.ordered
    end

    def show
      @poll = Current.user.polls.find(params[:id])
      @questions = @poll.questions.includes(:answers).ordered
    end

    def new
      @poll = Poll.new
    end

    def create
      @poll = Current.user.polls.build(poll_params)

      if @poll.save
        redirect_to author_poll_path(@poll), notice: "Poll was successfully created.", status: :see_other
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @poll = Current.user.polls.find(params[:id])
    end

    def update
      @poll = Current.user.polls.find(params[:id])
      if @poll.update(poll_params)
        redirect_to author_poll_path(@poll), notice: "Poll was successfully updated.", status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @poll = Current.user.polls.find(params[:id])
      @poll.destroy

      respond_to do |format|
        format.html { redirect_to author_polls_path, notice: "Poll was successfully destroyed." }
        format.turbo_stream { flash.now[:notice] = "Poll was successfully destroyed." }
      end
    end

    private

    def poll_params
      params.require(:poll).permit(:title)
    end

    def feature_enabled!
      return if user_signed_in? &&
        Flipper.enabled?(:polls, Current.user)

      raise ActionController::RoutingError.new("Not Found")
    end
  end
end
