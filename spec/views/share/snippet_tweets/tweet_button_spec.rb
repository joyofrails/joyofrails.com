require "rails_helper"

RSpec.describe Share::SnippetTweets::TweetButton, type: :view do
  it "renders" do
    snippet = instance_double(Snippet, **FactoryBot.attributes_for(:snippet))
    render Share::SnippetTweets::TweetButton.new(snippet)

    expect(rendered).to have_css("a[href*='x.com']")
  end
end
