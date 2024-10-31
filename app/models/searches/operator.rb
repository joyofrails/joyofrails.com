module Searches
  class Operator
    def self.symbol(str)
      case str
      when "+"
        :and
      when "-"
        :not
      when "|"
        :or
      else
        raise "Unknown operator: #{str}"
      end
    end

    def initialize(operator)
      @operator = self.class.symbol(operator)
    end

    def to_s
      @operator.to_s.upcase
    end

    def to_sym
      @operator.to_sym
    end
  end
end
