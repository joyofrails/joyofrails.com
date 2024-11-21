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
  describe "#resource" do
    it "represents a sitepress resource" do
      page = FactoryBot.create(:page, request_path: "/")

      expect(page.resource).to eq Sitepress.site.get("/")
    end
  end

  describe "#body" do
    it "delegates to resource" do
      page = FactoryBot.build(:page, request_path: "/articles/introducing-joy-of-rails")

      expect(page.body).to be_present
      expect(page.body).to eq page.resource.body
    end
  end

  describe "resource data methods" do
    it "delegates to resource data" do
      page = FactoryBot.build(:page, request_path: "/articles/introducing-joy-of-rails")

      %w[title description image meta_image toc author].each do |method|
        expect(page.send(method)).not_to be_nil, "Expected #{method} to be present"
        expect(page.send(method)).to eq(page.resource.data.send(method)), "Expected #{method} to match"
      end
    end
  end
end
