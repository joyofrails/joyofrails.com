module Share
  module Polls
    class Ballot < ApplicationComponent
      include Phlex::Rails::Helpers::ButtonTo
      include Phlex::Rails::Helpers::Routes
      include Phlex::Rails::Helpers::Tag
      include PhlexConcerns::NestedDomId

      attr_accessor :poll

      def initialize(poll)
        @poll = poll
      end

      def view_template
        div id: nested_dom_id(poll, "ballot") do
          poll.questions.ordered.each do |question|
            div id: nested_dom_id(poll, question),
              class: "question flex flex-col gap-2" do
              p { question.body }

              question.answers.ordered.each do |answer|
                div id: nested_dom_id(question, answer) do
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
  end
end
