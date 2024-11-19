# Custom type for ActiveRecord to deserialize vectors from vector columns
# enabled by sqlite-vec extensions which provides vec0 virtual tables.
module Types
  class Vector < ActiveModel::Type::Value
    include ActiveModel::Type::SerializeCastValue

    def type
      :vector
    end

    def deserialize(value)
      return value unless value.is_a?(::String)

      # When we initially created the vector column, we serialized the vector as JSON
      if value.start_with?("[")
        ActiveSupport::JSON.decode(value)
      else
        # Unpacks a float array from the binary string as represented in the
        # database. The format is "f*" per sqlite-vec docs. The "f*" template is
        # a "single-precision float directive" per Ruby docs
        # https://docs.ruby-lang.org/en/3.3/packed_data_rdoc.html
        #
        # There are minor precision issues when unpacking the binary string so
        # we prefer to use subqueries for embedding MATCH comparision over
        # deserializing/serialize in ActiveRecord.
        #
        value.unpack("f*")
      end
    end

    def serialize(value)
      ActiveSupport::JSON.encode(value) unless value.nil?
    end
  end
end
