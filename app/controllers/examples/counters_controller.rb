class Examples::CountersController < ApplicationController
  def show
    @examples_counter = Examples::Counter.new(count: get_session_count)
  end

  def update
    @examples_counter = Examples::Counter.new(count: get_session_count)

    @examples_counter.assign_attributes(examples_counter_params)
    session[:examples_counter] = @examples_counter.count

    redirect_to @examples_counter, status: :see_other
  end

  def destroy
    @examples_counter = Examples::Counter.new
    session.delete(:examples_counter)

    redirect_to @examples_counter, status: :see_other
  end

  private

  def get_session_count
    session[:examples_counter].to_i
  end

  def examples_counter_params
    params.require(:counter).permit(:count)
  end
end
