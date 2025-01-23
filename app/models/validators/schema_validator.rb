require "json-schema"
module Validators
  class SchemaValidator < ActiveModel::Validator
    def validate(record)
      schema = options.fetch(:schema)
      field_name = options.fetch(:field)
      value = record.send(field_name)

      unless JSON::Validator.validate(schema, value)
        record.errors.add(field_name, "does not comply to JSON Schema: #{schema.inspect}")
      end
    end
  end
end
