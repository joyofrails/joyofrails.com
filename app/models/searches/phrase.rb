module Searches
  class Phrase
    attr_accessor :phrase

    def initialize(phrase)
      @phrase = phrase
    end

    def to_s
      %("#{phrase}")
    end
  end
end
