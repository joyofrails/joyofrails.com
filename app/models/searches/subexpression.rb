module Searches
  class Subexpression
    attr_reader :expression

    def initialize(expression)
      @expression = expression
    end

    def to_s
      "(#{expression})"
    end
  end
end
