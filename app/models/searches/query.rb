module Searches
  class Query
    attr_accessor :expressions

    def self.parse!(query)
      ast = Searches::QueryParser.new.parse(query)

      Searches::QueryTransformer.new.apply(ast)
    rescue Parslet::ParseFailed => error
      raise Searches::ParseFailed, error.message
    end

    def self.parse(query)
      parse!(query)
    rescue Searches::ParseFailed
      nil
    end

    def initialize(expressions)
      @expressions = expressions
    end

    def to_s
      expressions.map(&:to_s).join(" ")
    end
  end
end
