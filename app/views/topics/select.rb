module Topics
  class Select < ApplicationComponent
    include Phlex::Rails::Helpers::CurrentPage
    include PhlexConcerns::FlexBlock

    attr_reader :topics, :attributes

    def initialize(topics = [], **attributes)
      @topics = topics
      @attributes = attributes
    end

    def view_template
      flex_block(attributes) do
        label(for: "topic", class: "block text-sm font-medium text-gray-700") do
          "Select a topic"
        end
        select(
          name: "topic",
          data: {
            :controller => "select-nav",
            :action => "select-nav#visit",
            "select-nav-turbo-frame-value" => "topics_mainbar"
          }
        ) do
          option(value: "") { "Start here" }
          topics.each do |topic|
            option(value: topic_path(topic), select: current_page?(topic_path(topic))) { topic.name }
          end
        end
      end
    end
  end
end
