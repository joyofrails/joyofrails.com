require "rails_helper"

RSpec.describe "snippets/new", type: :view do
  before(:each) do
    assign(:snippet, Snippet.new)
  end

  it "renders new snippet form" do
    render

    assert_select "form[action=?][method=?]", snippets_path, "post" do
    end
  end
end
