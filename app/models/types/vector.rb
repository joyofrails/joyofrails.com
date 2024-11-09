# Custom type for ActiveRecord to deserialize vectors from vector columns
# enabled by sqlite-vec extensions which provides vec0 virtual tables.
module Types
  class Vector < ActiveRecord::Type::Json
    def type
      :vector
    end

    def deserialize(value)
      return value unless value.is_a?(::String)

      begin
        value.unpack("F*")
      rescue
        nil
      end
    end
  end
end
