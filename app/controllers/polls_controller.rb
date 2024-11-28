class PollsController < ApplicationController
  before_action :authenticate_user!

  def index
    @polls = current_user.polls.ordered
  end

  def show
    @poll = current_user.polls.find(params[:id])
    @questions = @poll.questions.includes(:answers).ordered
  end

  def new
    @poll = Poll.new
  end

  def create
    @poll = current_user.polls.build(poll_params)

    if @poll.save
      respond_to do |format|
        format.html { redirect_to polls_path, notice: "Quote was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Quote was successfully created." }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @poll = current_user.polls.find(params[:id])
  end

  def update
    @poll = current_user.polls.find(params[:id])
    if @poll.update(poll_params)
      respond_to do |format|
        format.html { redirect_to polls_path, notice: "Quote was successfully updated." }
        format.turbo_stream { flash.now[:notice] = "Quote was successfully updated." }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @poll = current_user.polls.find(params[:id])
    @poll.destroy

    respond_to do |format|
      format.html { redirect_to polls_path, notice: "Quote was successfully destroyed." }
      format.turbo_stream { flash.now[:notice] = "Quote was successfully destroyed." }
    end
  end

  private

  def poll_params
    params.require(:poll).permit(:title)
  end
end
