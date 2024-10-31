module Searches
  class Phrase
    attr_accessor :phrase # Array of strings

    def initialize(phrase)
      @phrase = phrase
    end

    def to_s
      %("#{phrase.join(" ")}")
    end
  end
end
