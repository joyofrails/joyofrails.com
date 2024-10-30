require "rails_helper"

RSpec.describe Searches::QueryParser do
  subject(:parser) { described_class.new }

  it "can parse a simple query" do
    parse_tree = parser.parse("hello parslet")

    expect(parse_tree[:query]).to match([
      {clause: {term: kind_of(Parslet::Slice)}},
      {clause: {term: kind_of(Parslet::Slice)}}
    ])
  end

  it "ignores punctuation characters" do
    parse_tree = parser.parse("hello, parslet")

    expect(parse_tree[:query]).to match([
      {clause: {term: kind_of(Parslet::Slice)}},
      {clause: {term: kind_of(Parslet::Slice)}}
    ])
  end

  it "parses boolean operators" do
    expect(parser.parse("the +cat in the -hat")[:query]).to match([
      {clause: {term: kind_of(Parslet::Slice)}},
      {clause: {operator: kind_of(Parslet::Slice), term: kind_of(Parslet::Slice)}},
      {clause: {term: kind_of(Parslet::Slice)}},
      {clause: {term: kind_of(Parslet::Slice)}},
      {clause: {operator: kind_of(Parslet::Slice), term: kind_of(Parslet::Slice)}}
    ])
  end

  it "parses phrases" do
    expect(parser.parse(%("cat in the hat" -green +ham))[:query]).to match([
      {clause: {phrase: [
        {term: kind_of(Parslet::Slice)},
        {term: kind_of(Parslet::Slice)},
        {term: kind_of(Parslet::Slice)},
        {term: kind_of(Parslet::Slice)}
      ]}},
      {clause: {operator: kind_of(Parslet::Slice), term: kind_of(Parslet::Slice)}},
      {clause: {operator: kind_of(Parslet::Slice), term: kind_of(Parslet::Slice)}}
    ])
  end

  it "parses phrases" do
    expect(parser.parse(%('cat in the hat' -green +ham))[:query]).to match([
      {clause: {phrase: [
        {term: kind_of(Parslet::Slice)},
        {term: kind_of(Parslet::Slice)},
        {term: kind_of(Parslet::Slice)},
        {term: kind_of(Parslet::Slice)}
      ]}},
      {clause: {operator: kind_of(Parslet::Slice), term: kind_of(Parslet::Slice)}},
      {clause: {operator: kind_of(Parslet::Slice), term: kind_of(Parslet::Slice)}}
    ])
  end
end
