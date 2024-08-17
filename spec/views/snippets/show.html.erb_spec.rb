require "rails_helper"

RSpec.describe "snippets/show", type: :view do
  before(:each) do
    assign(:snippet, Snippet.create!)
  end

  it "renders attributes in <p>" do
    render
  end
end
