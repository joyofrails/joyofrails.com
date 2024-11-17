module Pages
  class Topics < ApplicationComponent
    attr_reader :topics

    def initialize(topics: [])
      @topics = topics
    end

    def view_template
      if topics.empty?
        plain ""
        return
      end

      p(class: "topics") do
        topics.each do |topic|
          a(href: topic_path(topic), class: "topic") do
            "##{topic.try(:slug) || topic}"
          end
          whitespace
        end
      end
    end
  end
end
