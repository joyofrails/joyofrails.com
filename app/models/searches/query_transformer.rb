module Searches
  class QueryTransformer < Parslet::Transform
    rule(term: simple(:term)) { Term.new(term.to_s) }
    rule(phrase: sequence(:phrase)) { Phrase.new(phrase) }
    rule(condition: {left: simple(:left), operator: simple(:operator), right: subtree(:right)}) do
      Condition.new(left, Operator.new(operator), right)
    end
    rule(subexpression: simple(:expression)) { Subexpression.new(expression) }
    rule(query: sequence(:expressions)) { Searches::Query.new(expressions) }
  end
end
