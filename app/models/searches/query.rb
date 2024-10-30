module Searches
  class Query
    attr_accessor :expressions

    def initialize(expressions)
      @expressions = expressions
    end

    def to_s
      expressions(&:to_s).join(" ")
    end
  end
end
