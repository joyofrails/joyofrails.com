# == Schema Information
#
# Table name: application_events
#
#  id         :string           not null, primary key
#  data       :text             not null
#  metadata   :text
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_application_events_on_created_at  (created_at)
#
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
