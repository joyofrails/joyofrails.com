module Share
  module Polls
    class Results < ApplicationComponent
      include Phlex::Rails::Helpers::Pluralize
      include Phlex::Rails::Helpers::DOMID

      attr_reader :poll, :question

      def initialize(poll, question)
        @poll = poll
        @question = question
      end

      def view_template
        div id: dom_id(question, :results), class: "question flex flex-col gap-2" do
          p { question.body }

          question.answers.ordered.each do |answer|
            render AnswerBar.new(answer, question)
          end

          div(class: "p-2") do
            p(class: "text-small font-extrabold") { pluralize question.votes_count, "vote" }
          end
        end
      end

      private

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
