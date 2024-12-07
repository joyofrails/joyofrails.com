module Share
  module Polls
    class Ballot < ApplicationComponent
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::DOMID
      include Phlex::Rails::Helpers::Pluralize

      attr_reader :poll, :question

      def initialize(poll, question, voted: false)
        @poll = poll
        @question = question
        @voted = voted
      end

      def view_template
        div id: dom_id(question, :ballot), class: "question flex flex-col gap-2" do
          p { question.body }

          question.answers.ordered.each do |answer|
            div id: dom_id(answer) do
              button_to answer.body,
                share_poll_votes_path(poll, answer_id: answer.id),
                class: "button transparent slim"
            end
          end
        end
      end
    end
  end
end
