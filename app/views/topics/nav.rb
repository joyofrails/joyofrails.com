module Topics
  class Nav < ApplicationComponent
    include Phlex::Rails::Helpers::CurrentPage
    include Phlex::Rails::Helpers::DOMID
    include PhlexConcerns::FlexBlock

    attr_reader :topics, :attributes

    def initialize(topics = [], **attributes)
      @topics = topics
      @attributes = attributes
    end

    def view_template
      topics_select
      topics_list
    end

    def topics_select
      flex_block(class: "lg:hidden") do
        label(for: "topic", class: "block text-sm font-medium text-gray-700") do
          "Select a topic"
        end
        select(
          name: "topic",
          data: {
            :controller => "select-nav",
            :action => "select-nav#visit",
            "select-nav-turbo-frame-value" => "topics-mainbar"
          }
        ) do
          option(value: "") { "Start here" }
          topics.each do |topic|
            option(
              value: topic_path(topic),
              selected: current_page?(topic_path(topic))
            ) do
              topic.name
            end
          end
        end
      end
    end

    def topics_list
      topics.each do |topic|
        div id: dom_id(topic), class: "text-small mb-2 hidden lg:block" do
          a(
            href: topic_path(topic),
            data: {
              turbo_frame: "topics-mainbar"
            }
          ) do
            topic.name
          end

          whitespace
          span(class: "text-faint") do
            plain "(#{topic.pages_count})"
          end
        end
      end
    end
  end
end
