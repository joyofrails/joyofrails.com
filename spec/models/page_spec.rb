# == Schema Information
#
# Table name: pages
#
#  id           :string           not null, primary key
#  indexed_at   :datetime
#  published_at :datetime
#  request_path :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_pages_on_indexed_at    (indexed_at)
#  index_pages_on_published_at  (published_at)
#  index_pages_on_request_path  (request_path) UNIQUE
#
require "rails_helper"

RSpec.describe Page, type: :model do
  it "represents a sitepress resource" do
    page = FactoryBot.create(:page, request_path: "/")

    expect(page.resource).to eq Sitepress.site.get("/")
  end
end
