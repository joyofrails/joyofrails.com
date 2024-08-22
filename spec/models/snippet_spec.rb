require "rails_helper"

RSpec.describe Snippet, type: :model do
  describe "#language=" do
    subject(:snippet) { Snippet.new }

    context "when explicit" do
      it "sets the language to a recognized Rouge::Lexer tag" do
        snippet.language = "ruby"
        expect(snippet.language).to eq("ruby")

        snippet.valid?
        expect(snippet.errors[:language]).to be_blank
      end

      it "sets the language to an unrecognized tag and raises a validation error" do
        snippet.language = "invalid_language"

        snippet.valid?

        expect(snippet.errors[:language]).to include("is not a recognized language")
      end
    end

    context "when auto" do
      it "sets the language to 'auto' and attempts to guess the Rouge::Lexer tag" do
        snippet.assign_attributes(language: "auto")

        snippet.valid?

        expect(snippet.errors[:language]).to include("could not be auto-detected from filename or source")
      end

      it "detects the language from the filename" do
        snippet.assign_attributes(language: "auto", filename: "example.rb")

        snippet.valid?

        expect(snippet.language).to eq("ruby")
        expect(snippet.errors[:language]).to be_blank
      end

      it "detects the language from the source" do
        source = File.read(Rails.root.join("spec/fixtures/snippets/example.rb"))
        snippet.assign_attributes(language: "auto", source: source)

        snippet.valid?

        expect(snippet.language).to eq("ruby")
        expect(snippet.errors[:language]).to be_blank
      end
    end
  end
end
