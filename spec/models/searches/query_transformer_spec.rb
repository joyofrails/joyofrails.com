require "rails_helper"

RSpec.describe Searches::QueryTransformer do
  subject(:transformer) { described_class.new }
  let(:parser) { Searches::QueryParser.new }

  it "transforms a simple query" do
    ast = parser.parse("hello parslet")
    query = transformer.apply(ast)

    expect(query.to_s).to eq("hello parslet")

    expect { Page.search(query.to_s) }.not_to raise_error
  end

  it "transforms a query with boolean operators" do
    ast = parser.parse(%(the + cat))

    query = transformer.apply(ast)

    expect(query.to_s).to eq("the AND cat")

    expect { Page.search(query.to_s) }.not_to raise_error
  end

  it "transforms a query with boolean operators and phrase at the start" do
    ast = parser.parse(%(the + cat | "the hat"))

    query = transformer.apply(ast)

    expect(query.to_s).to eq(%(the AND cat OR "the hat"))

    expect { Page.search(query.to_s) }.not_to raise_error
  end

  it "parses a query with boolean operators and phrase at the end" do
    ast = parser.parse(%("cat in the hat" -green +ham))

    query = transformer.apply(ast)

    expect(query.to_s).to eq(%("cat in the hat" NOT green AND ham))

    expect { Page.search(query.to_s) }.not_to raise_error
  end

  it "parses a query with a subexpression" do
    ast = parser.parse("the (cat | hat)")

    query = transformer.apply(ast)

    expect(query.to_s).to eq("the (cat OR hat)")

    expect { Page.search(query.to_s) }.not_to raise_error
  end

  it "parses a query with a subexpression" do
    ast = parser.parse("the (cat | hat)")

    query = transformer.apply(ast)

    expect(query.to_s).to eq("the (cat OR hat)")

    expect { Page.search(query.to_s) }.not_to raise_error
  end
end
