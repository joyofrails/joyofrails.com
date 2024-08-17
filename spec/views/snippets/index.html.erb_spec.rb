require "rails_helper"

RSpec.describe "snippets/index", type: :view do
  before(:each) do
    assign(:snippets, [
      Snippet.create!,
      Snippet.create!
    ])
  end

  it "renders a list of snippets" do
    render
    # cell_selector = "div>p"
  end
end
