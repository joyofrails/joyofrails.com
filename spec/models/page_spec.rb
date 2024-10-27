require "rails_helper"

RSpec.describe Page, type: :model do
  it "represents a sitepress resource" do
    page = Page.find_or_create_by!(request_path: "/")

    expect(page.resource).to eq Sitepress.site.get("/")
  end
end
