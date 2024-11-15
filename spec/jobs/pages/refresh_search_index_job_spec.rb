require "rails_helper"

RSpec.describe Pages::RefreshSearchIndexJob, type: :job do
  it "doesn’t blow up" do
    page_1 = FactoryBot.create(:page, :published, request_path: "/articles/introducing-joy-of-rails")
    page_2 = FactoryBot.create(:page, :published, request_path: "/articles/custom-color-schemes-with-ruby-on-rails")
    page_3 = FactoryBot.create(:page, :unpublished, request_path: "/articles/joy-of-rails-2")

    described_class.perform_now

    expect(Page.join_search_index).to include(page_1, page_2)
    expect(Page.join_search_index).not_to include(page_3)
  end
end