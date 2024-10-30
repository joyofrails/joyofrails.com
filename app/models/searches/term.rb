module Searches
  class Term
    attr_accessor :term

    def initialize(term)
      @term = term
    end

    def to_s
      @term.to_s
    end
  end
end
