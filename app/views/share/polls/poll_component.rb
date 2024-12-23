class Share::Polls::PollComponent < ApplicationComponent
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_accessor :poll

  def initialize(poll, completed: false)
    @poll = poll
    @completed = completed
  end

  def view_template
    turbo_frame_tag poll, class: "poll joy-border-subtle rounded" do
      header(class: "px-4 pt-2 pb-2") do
        h5 do
          plain poll.title
        end
      end

      div(class: "p-4 flex flex-col gap-2") do
        questions
          .each do |question|
            render Share::Polls::QuestionComponent.new(
              poll,
              question,
              voted: completed?
            )
          end
      end
    end
  end

  def questions
    @questions ||= poll.questions.includes(:answers).ordered
  end

  def completed? = !!@completed
end
