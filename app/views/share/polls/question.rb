module Share
  module Polls
    class Question < ApplicationComponent
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::Pluralize
      include Phlex::Rails::Helpers::TurboFrameTag
      include Phlex::Rails::Helpers::TurboStreamFrom

      attr_reader :poll, :question

      def initialize(poll:, question:, voted: false)
        @poll = poll
        @question = question
        @voted = voted
      end

      def view_template
        turbo_frame_tag question, class: "question flex flex-col gap-2" do
          if voted?
            results
          else
            ballot
          end
        end
        turbo_stream_from question
      end

      def ballot
        p { question.body }

        question.answers.ordered.each do |answer|
          div id: dom_id(answer) do
            button_to answer.body,
              share_poll_votes_path(poll, answer_id: answer.id),
              class: "button transparent slim"
          end
        end
      end

      def results
        p { question.body }

        question.answers.ordered.each do |answer|
          render AnswerBar.new(answer, question)
        end

        div(class: "p-2") do
          p(class: "text-small font-extrabold") { pluralize question.votes_count, "vote" }
        end
      end

      private

      def voted? = !!@voted

      class AnswerBar < ApplicationComponent
        include Phlex::Rails::Helpers::DOMID
        include Phlex::Rails::Helpers::NumberToPercentage

        attr_reader :answer, :question

        def initialize(answer, question)
          @answer = answer
          @question = question
        end

        def view_template
          div(
            id: dom_id(answer),
            class: "answer flex justify-between items-center flex-row relative"
          ) do
            if answer.votes_count.positive?
              div(
                style: {
                  width: vote_percentage(answer, question)
                },
                class: "absolute rounded border bar"
              )
            end

            div(class: "px-3 py-1 z-10") do
              plain answer.body
            end

            div(class: "px-3 py-1 z-10") do
              vote_percentage(answer, question)
            end
          end
        end

        def vote_percentage(answer, question)
          return "0%" if question.votes_count.zero?

          number_to_percentage((answer.votes_count * 100) / question.votes_count, precision: 1)
        end
      end

      private_constant :AnswerBar
    end
  end
end
