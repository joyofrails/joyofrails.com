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
  end
end
