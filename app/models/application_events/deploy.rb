module ApplicationEvents
  class Deploy < ::ApplicationEvent
    DATA_SCHEMA = {
      "type" => "object",
      "required" => ["sha"],
      "properties" => {
        "sha" => {"type" => "string"}
      }
    }.freeze

    validates_with Validators::SchemaValidator, field: :data, schema: DATA_SCHEMA

    def self.record!(sha: nil)
      sha = current_sha if sha.nil?

      create! data: {sha: sha}
    end

    def self.current_sha
      Repo.new.rev_parse("HEAD")
    rescue => e
      Honeybadger.notify(e)

      "UNKNOWN"
    end
  end
end
