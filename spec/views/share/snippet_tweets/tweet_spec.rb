require "rails_helper"

RSpec.describe Share::SnippetTweets::Tweet, type: :view do
  it "renders" do
    snippet = instance_double(Snippet, **FactoryBot.attributes_for(:snippet))
    render Share::SnippetTweets::Tweet.new(snippet)

    expect(rendered).to have_css(".snippet-tweet")
  end
end
