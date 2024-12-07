module Share
  module Polls
    class QuestionComponent < ApplicationComponent
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::TurboStreamFrom

      attr_reader :poll, :question

      def initialize(poll, question, voted: false)
        @poll = poll
        @question = question
        @voted = voted
      end

      def view_template
        turbo_frame_tag question, class: "question flex flex-col gap-2" do
          if voted?
            render Share::Polls::Results.new(poll, question)
          else
            render Share::Polls::Ballot.new(poll, question)
          end
        end
        turbo_stream_from question
      end

      private

      def voted? = !!@voted
    end
  end
end
