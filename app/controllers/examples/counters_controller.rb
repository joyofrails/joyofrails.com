class Examples::CountersController < ApplicationController
  def show
    @examples_counter = Examples::Counter.new(count: get_session_count)
  end

  def update
    @examples_counter = Examples::Counter.new(count: get_session_count)

    if examples_counter_params.empty?
      return render :show, status: :unprocessable_entity
    end

    @examples_counter.assign_attributes(examples_counter_params)
    session[:examples_counter] = @examples_counter.count

    respond_to do |format|
      format.html {
        redirect_to @examples_counter, notice: "Count was successfully updated.", status: :see_other
      }
      format.turbo_stream {
        render turbo_stream: turbo_stream_replace_counter(@examples_counter)
      }
    end
  end

  def destroy
    @examples_counter = Examples::Counter.new(count: 0)
    session.delete(:examples_counter)

    respond_to do |format|
      format.html {
        redirect_to @examples_counter, notice: "Count was successfully reset.", status: :see_other
      }
      format.turbo_stream {
        render turbo_stream: turbo_stream_replace_counter(@examples_counter)
      }
    end
  end

  private

  def turbo_stream_replace_counter(counter)
    turbo_stream.replace(
      counter,
      partial: "examples/counters/counter",
      locals: {counter: counter}
    )
  end

  def get_session_count
    session[:examples_counter].to_i
  end

  def examples_counter_params
    return {} unless params.key?(:counter)
    params.require(:counter).permit(:count)
  end
end
