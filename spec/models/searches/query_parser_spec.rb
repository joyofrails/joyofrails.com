require "rails_helper"

RSpec.describe Searches::QueryParser do
  subject(:parser) { described_class.new }

  def parse_query(query)
    ast = parser.parse(query)
    puts ast if ENV["DEBUG"]
    ast
  rescue Parslet::ParseFailed => error
    puts error.parse_failure_cause.ascii_tree
    raise error
  end

  it "can parse a simple query" do
    parse_tree = parse_query("hello parslet")

    expect(parse_tree[:query].flat_map(&:keys)).to eq([:term, :term])
  end

  it "parses boolean operators" do
    expect(parse_query(%(the + cat | "the hat"))[:query]).to match([
      hash_including(
        condition: hash_including(
          :operator,                          # +
          left: hash_including(:term),        # the
          right: hash_including(
            condition: hash_including(
              :operator,                      # |
              left: hash_including(:term),    # cat
              right: hash_including(:phrase)  # "the hat"
            )
          )
        )
      )
    ])
  end

  it "parses double quoted phrases with logic" do
    expect(parse_query(%("cat in the hat" -green +ham))[:query]).to match([
      hash_including(
        condition: hash_including(
          :operator,
          left: hash_including(:phrase),
          right: hash_including(
            condition: hash_including(
              :operator,
              left: hash_including(:term),
              right: hash_including(:term)
            )
          )
        )
      )
    ])
  end

  it "parses single quoted phrases with logic" do
    expect(parse_query(%('cat in the hat' -green +ham))[:query]).to match([
      hash_including(
        condition: hash_including(
          :operator,
          left: hash_including(:phrase),
          right: hash_including(
            condition: hash_including(
              :operator,
              left: hash_including(:term),
              right: hash_including(:term)
            )
          )
        )
      )
    ])
  end
end
