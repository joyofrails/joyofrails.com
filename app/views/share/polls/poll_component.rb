class Share::Polls::PollComponent < ApplicationComponent
  include Phlex::Rails::Helpers::TurboFrameTag

  attr_accessor :poll, :device_uuid

  def initialize(poll, device_uuid:)
    @poll = poll
    @device_uuid = device_uuid
  end

  def view_template
    turbo_frame_tag poll, class: "poll joy-border-subtle rounded" do
      header(class: "px-4 pt-2 pb-2") do
        h5 do
          plain poll.title
        end
      end

      div(class: "p-4 flex flex-col gap-2") do
        poll
          .questions
          .includes(:answers)
          .ordered
          .each do |question|
            render Share::Polls::Question.new(
              poll:,
              question:,
              voted: question.voted?(device_uuid: device_uuid)
            )
          end
      end
    end
  end
end
