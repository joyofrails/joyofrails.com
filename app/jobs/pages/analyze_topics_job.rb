# Credit for this topics analysis job logic and OpenAI prompt goes to
# rubyvideo.dev. Please support their platform!

module Pages
  class AnalyzeTopicsJob < ApplicationJob
    queue_as :default

    def perform(page)
      response = client.chat(
        parameters: {
          model: "gpt-4o-mini",
          response_format: response_format,
          messages: messages(page)
        }
      )

      topics = extract_topics(response)

      page.topics = Topic.create_from_list(topics)
      page.save!

      page
    end

    private

    def extract_topics(response)
      JSON.parse(response.dig("choices", 0, "message", "content"))["topics"]
    rescue => e
      Honeybadger.notify("[#{self.class}] Failed to parse topics from response: #{raw_response}, #{e}")

      raise e if Rails.env.local?

      []
    end

    def response_format
      {
        type: "json_schema",
        json_schema: {
          name: "page_topics",
          schema: {
            type: "object",
            properties: {
              topics: {
                type: "array",
                description: "A list of topics related to the article.",
                items: {
                  type: "string",
                  description: "A single topic."
                }
              }
            },
            required: ["topics"],
            additionalProperties: false
          },
          strict: true
        }
      }
    end

    def client
      OpenAI::Client.new
    end

    def messages(page)
      [
        {role: "system", content: "You are a helpful assistant skilled in assigned a list of predefined topics to an article."},
        {role: "user", content: prompt(page)}
      ]
    end

    def approved_topics
      Topic.approved.pluck(:name)
    end

    def rejected_topics
      Topic.rejected.pluck(:name)
    end

    def prompt(page)
      <<~PROMPT
        You are tasked with figuring out of the list of provided topics matches an article based on the article content and its metadata. Follow these steps carefully:

        1. First, read through the entire list of existing topics for other articles.
        <topics>
          #{approved_topics.join(", ")}
        </topics>

        2. Next, read through the entire list of topics that we have already rejected for other articles.
        <rejected_topics>
          #{rejected_topics.join(", ")}
        </rejected_topics>

        3. Now review the metadata of the article:
        <metadata>
          - title: #{page.title}
          - description: #{page.description}
          - url: #{page.request_path}
          - current topics: #{page.topics.pluck(:name).join(", ")}
        </metadata>

        4. Carefully read through the entire article:
        <article>
        #{page.body_text}
        </article>

        5. Pick 3 to 4 topics that would describe the article best.
           Prefer current topics for the article, if any, unless the topics no longer apply. Next, prefer topics from the list of existing topics but you may create new ones if necessary.

           If you create a new topic, please ensure that it is relevant to the content of the article and match the recommended topics kind.
           Also for new topics please ensure they are not a synonym of an existing topic.
            - Make sure it fits the overall theme of this website, it's a website for sharing tutorials about Ruby on Rails, so it should have something to do with Ruby, Rails, Web, Programming, Teams, People or Tech.
            - Ruby framework names (examples: Rails, Sinatra, Hanami, Ruby on Rails, ...)
            - Ruby gem names
            - Design patterns names (examples: MVC, MVP, Singleton, Observer, Strategy, Command, Decorator, Composite, Facade, Proxy, Mediator, Memento, Observer, State, Template Method, Visitor, ...)
            - Database names (examples: PostgreSQL, MySQL, MongoDB, Redis, Elasticsearch, Cassandra, CouchDB, SQLite, ...)
            - front end frameworks names (examples: React, Vue, Angular, Ember, Svelte, Stimulus, Preact, Hyperapp, Inferno, Solid, Mithril, Riot, Polymer, Web Components, Hotwire, Turbo, StimulusReflex, Strada ...)
            - front end CSS libraries and framework names (examples: Tailwind, Bootstrap, Bulma, Material UI, Foundation, ...)
            - front end JavaScript libraries names (examples: jQuery, D3, Chart.js, Lodash, Moment.js, ...)

          Topics are typically one or two words long, with some exceptions such as "Ruby on Rails"

        6. Format your topics you picked as a JSON object with the following schema:
          {
            "topics": ["topic1", "topic2", "topic3"]
          }

        7. Ensure that your summary is:
          - relevant to the content of the article and match the recommended topics kind
          - Free of personal opinions or external information not present in the provided content

        8. Output your JSON object containing the list of topics in the JSON format.
      PROMPT
    end
  end
end
