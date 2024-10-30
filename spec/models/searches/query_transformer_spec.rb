require "rails_helper"

RSpec.describe Searches::QueryTransformer do
  subject(:transformer) { described_class.new }
  let(:parser) { Searches::QueryParser.new }

  it "transforms a simple query" do
    ast = parser.parse("hello parslet")
    query = transformer.apply(ast)

    expect(query.to_s).to eq("hello parslet")
  end

  it "transforms a query with boolean operators" do
    ast = parser.parse(%(the + cat))

    query = transformer.apply(ast)

    expect(query.to_s).to eq("the AND cat")
  end

  it "transforms a query with boolean operators and phrase at the start" do
    ast = parser.parse(%(the + cat | "the hat"))

    query = transformer.apply(ast)

    expect(query.to_s).to eq(%(the AND cat OR "the hat"))
  end

  it "parses a query with boolean operators and phrase at the end" do
    ast = parser.parse(%("cat in the hat" -green +ham))

    query = transformer.apply(ast)

    expect(query.to_s).to eq(%("cat in the hat" NOT green AND ham))
  end
end
