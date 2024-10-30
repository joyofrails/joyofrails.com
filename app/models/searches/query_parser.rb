module Searches
  class QueryParser < Parslet::Parser
    rule(:term) { match(%([^\s"'])).repeat(1).as(:term) }

    rule(:clause) { (operator.maybe >> (phrase | term)).as(:clause) }
    rule(:phrase) do
      (
        (squote >> (term >> space.maybe).repeat >> squote) |
        (dquote >> (term >> space.maybe).repeat >> dquote)
      ).as(:phrase)
    end

    rule(:dquote) { str(%(")) }
    rule(:squote) { str(%(')) }
    rule(:operator) { (str("+") | str("-")).as(:operator) }

    rule(:space) { match('\s').repeat(1) }
    rule(:space?) { space.maybe }

    rule(:query) { (clause >> space?).repeat.as(:query) }
    root(:query)
  end
end
