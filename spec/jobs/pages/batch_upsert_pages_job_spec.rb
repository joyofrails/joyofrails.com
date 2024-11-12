require "rails_helper"

RSpec.describe Pages::BatchUpsertPagesJob, type: :job do
  it "creates pages for sitepress resources" do
    described_class.perform_now

    expect(Page.count).to eq(
      SitepressArticle.all.resources.size +
      SitepressSlashPage.all.resources.size
    )

    expect(Page.pluck(:request_path)).to include("/articles/custom-color-schemes-with-ruby-on-rails")
  end

  it "is idempotent" do
    described_class.perform_now

    expect {
      described_class.perform_now
    }.not_to change(Page, :count)
  end
end
