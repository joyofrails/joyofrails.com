require "rails_helper"

RSpec.describe ErbMarkdown do
  describe "#preprocess" do
    subject { described_class.new }
    it "doesn't alter markdown" do
      expect(subject.preprocess("## Hello")).to eq("## Hello")
    end

    it "processes unfenced erb" do
      expect(subject.preprocess("<%= 1 + 1 %>")).to eq("2")
    end

    it "does not process inline fenced erb" do
      expect(subject.preprocess("`<%= 1 + 1 %>`")).to eq("`<%= 1 + 1 %>`")
    end

    it "handles multiline fenced erb" do
      expect(subject.preprocess("```\n<%= 1 + 1 %>\n```")).to eq("```\n<%= 1 + 1 %>\n```")
    end

    it "handles multiline fenced with multiple erbs" do
      html = <<~HTML
        ```
        <%= 1 + 1 %>
        <%= 2 + 2 %>
        ```
      HTML
      expect(subject.preprocess(html)).to eq(html)
    end

    it "processes erb outside fence and skips inside fence" do
      given_html = <<~HTML
        <%= 1 + 1 %>
        ```
        <%= 1 + 1 %>
        <%= 2 + 2 %>
        ```
      HTML
      processed_html = <<~HTML
        2
        ```
        <%= 1 + 1 %>
        <%= 2 + 2 %>
        ```
      HTML
      expect(subject.preprocess(given_html)).to eq(processed_html)
    end
  end
end
