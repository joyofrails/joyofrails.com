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
      [
        "A/B Testing",
        "Accessibility (a11y)",
        "ActionCable",
        "ActionMailbox",
        "ActionMailer",
        "ActionPack",
        "ActionText",
        "ActionView",
        "ActiveJob",
        "ActiveModel",
        "ActiveRecord",
        "ActiveStorage",
        "ActiveSupport",
        "Algorithms",
        "Android",
        "Angular.js",
        "Arel",
        "Artificial Intelligence (AI)",
        "Assembly",
        "Authentication",
        "Authorization",
        "Automation",
        "Awards",
        "Background jobs",
        "Behavior-Driven Development (BDD)",
        "Blogging",
        "Bootstrapping",
        "Bundler",
        "Business Logic",
        "Business",
        "Caching",
        "Capybara",
        "Career Development",
        "CI/CD",
        "Client-Side Rendering",
        "Code Golfing",
        "Code Organization",
        "Code Quality",
        "Command Line Interface (CLI)",
        "Communication",
        "Communication",
        "Community",
        "Compiling",
        "Components",
        "Computer Vision",
        "Concurrency",
        "Containers",
        "Content Management System (CMS)",
        "Content Management",
        "Continuous Integration (CI)",
        "Contributing",
        "CRuby",
        "Crystal",
        "CSS",
        "Data Analysis",
        "Data Integrity",
        "Data Migrations",
        "Data Persistence",
        "Data Processing",
        "Database Sharding",
        "Databases",
        "Debugging",
        "Dependency Management",
        "Deployment",
        "Design Patterns",
        "Developer Expierience (DX)",
        "Developer Tooling",
        "Developer Tools",
        "Developer Workflows",
        "DevOps",
        "Distributed Systems",
        "Diversity & Inclusion",
        "Docker",
        "Documentation Tools",
        "Documentation",
        "Domain Driven Design",
        "Domain Specific Language (DSL)",
        "dry-rb",
        "Duck Typing",
        "E-Commerce",
        "Early-Career Devlopers",
        "Editor",
        "Elm",
        "Encoding",
        "Encryption",
        "Engineering Culture",
        "Error Handling",
        "Ethics",
        "Event Sourcing",
        "Fibers",
        "Flaky Tests",
        "Frontend",
        "Functional Programming",
        "Game Shows",
        "Games",
        "Geocoding",
        "git",
        "Go",
        "Graphics",
        "GraphQL",
        "gRPC",
        "Hacking",
        "Hanami",
        "Hotwire",
        "HTML",
        "HTTP API",
        "Hybrid Apps",
        "Indie Developer",
        "Inspiration",
        "Integrated Development Environment (IDE)",
        "Integration Test",
        "Internals",
        "Internationalization (I18n)",
        "Interview",
        "iOS",
        "Java Virtual Machine (JVM)",
        "JavaScript",
        "Job Interviewing",
        "JRuby",
        "JSON Web Tokens (JWT)",
        "Just-In-Time (JIT)",
        "Kafka",
        "Keynote",
        "Language Server Protocol (LSP)",
        "Large Language Models (LLM)",
        "Leadership",
        "Legacy Applications",
        "Licensing",
        "Lightning Talks",
        "Linters",
        "Live Coding",
        "Localization (L10N)",
        "Logging",
        "Machine Learning",
        "Majestic Monolith",
        "Markup",
        "Math",
        "Memory Managment",
        "Mental Health",
        "Mentorship",
        "MFA/2FA",
        "Microcontroller",
        "Microservices",
        "Minimum Viable Product (MVP)",
        "Minitest",
        "MJIT",
        "Mocking",
        "Model-View-Controller (MVC)",
        "Monitoring",
        "Monolith",
        "mruby",
        "Multitenancy",
        "Music",
        "MySQL",
        "Naming",
        "Native Apps",
        "Native Extensions",
        "Networking",
        "Object-Oriented Programming (OOP)",
        "Object-Relational Mapper (ORM)",
        "Observability",
        "Offline-First",
        "Open Source",
        "Organizational Skills",
        "Pair Programming",
        "Panel Discussion",
        "Parallelism",
        "Parsing",
        "Passwords",
        "People Skills",
        "Performance",
        "Personal Development",
        "Phlex",
        "Podcasts",
        "PostgreSQL",
        "Pricing",
        "Privacy",
        "Productivity",
        "Profiling",
        "Progressive Web Apps (PWA)",
        "Project Planning",
        "Quality Assurance (QA)",
        "Questions and Anwsers (Q&A)",
        "Rack",
        "Ractors",
        "Rails at Scale",
        "Rails Engine",
        "Rails Plugins",
        "Rails Upgrades",
        "Railties",
        "React.js",
        "Real-Time Applications",
        "Refactoring",
        "Regex",
        "Remote Work",
        "Reporting",
        "REST API",
        "REST",
        "RJIT",
        "Robot",
        "RPC",
        "RSpec",
        "Ruby Implementations",
        "Ruby on Rails",
        "Ruby VM",
        "Rubygems",
        "Rust",
        "Scaling",
        "Science",
        "Security Vulnerability",
        "Security",
        "Selenium",
        "Server-side Rendering",
        "Servers",
        "Service Objects",
        "Shoes.rb",
        "Sidekiq",
        "Sinatra",
        "Single Page Applications (SPA)",
        "Software Architecture",
        "Sonic Pi",
        "Sorbet",
        "SQLite",
        "Startups",
        "Static Typing",
        "Stimulus.js",
        "Structured Query Language (SQL)",
        "Success Stories",
        "Swift",
        "Syntax",
        "System Programming",
        "System Test",
        "Tailwind CSS",
        "Teaching",
        "Team Building",
        "Teams",
        "Teamwork",
        "Templating",
        "Template Engine",
        "Test Coverage",
        "Test Framework",
        "Test-Driven Development",
        "Testing",
        "Testing",
        "Threads",
        "Timezones",
        "Tips & Tricks",
        "Trailblazer",
        "Translation",
        "Transpilation",
        "TruffleRuby",
        "Turbo Native",
        "Turbo",
        "Turbo Frames",
        "Turbo Streams",
        "Type Checking",
        "Types",
        "Typing",
        "UI Design",
        "Unit Test",
        "Usability",
        "User Interface (UI)",
        "Version Control",
        "ViewComponent",
        "Views",
        "Virtual Machine",
        "Vue.js",
        "Web Components",
        "Web Server",
        "Websockets",
        "why the lucky stiff",
        "Workshop",
        "Writing",
        "YARV (Yet Another Ruby VM)",
        "YJIT (Yet Another Ruby JIT)"
      ]
    end

    def rejected_topics
      [
        "Politics",
        "Religion",
        "Custom Settings",
        "Dynamic Rendering"
      ]
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
        </metadata>

        4. Carefully read through the entire article:
        <article>
        #{page.body_text}
        </article>

        5. Pick 3 to 4 topics that would describe the article best.
           Prefer topics from the list of existing topics but you may create new ones if necessary.

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
