module Searches
  class QueryParser < Parslet::Parser
    rule(:dquote) { str(%(")) }
    rule(:squote) { str(%(')) }
    rule(:lparen) { str("(") }
    rule(:rparen) { str(")") }

    rule(:space) { match('\s').repeat(1) }
    rule(:space?) { space.maybe }

    rule(:operator) { (str("+") | str("-") | str("|")).as(:operator) >> space? }
    rule(:term) { match[%(a-zA-Z0-9_)].repeat(1).as(:term) >> space? }
    rule(:phrase) do
      (
        (squote >> (term >> space?).repeat >> squote) |
        (dquote >> (term >> space?).repeat >> dquote)
      ).as(:phrase) >> space?
    end

    rule(:condition) { (token.as(:left) >> operator >> expression.as(:right)).as(:condition) }
    rule(:token) { phrase | term }
    rule(:expression) { (condition | token) }

    rule(:subexpression) { (lparen >> expression.as(:subexpression) >> rparen) }

    rule(:query) { (expression | subexpression).repeat.as(:query) }
    root(:query)
  end
end
