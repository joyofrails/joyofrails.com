require "rails_helper"

RSpec.describe Pages::BatchUpsertPagesJob, type: :job do
  it "creates pages for sitepress resources" do
    described_class.perform_now

    expect(Page.count).to eq(SitepressPage.all.resources.size)

    expect(Page.pluck(:request_path)).to include("/articles/custom-color-schemes-with-ruby-on-rails")
  end

  it "is idempotent" do
    described_class.perform_now

    expect {
      described_class.perform_now
    }.not_to change(Page, :count)
  end

  it "handles limit argument" do
    expect {
      described_class.perform_now(limit: 3)
    }.to change(Page, :count).by(3)

    expect {
      described_class.perform_now(limit: 3)
    }.to change(Page, :count).by(3)
  end

  it "enqueues refresh search index job and analyze topics job" do
    allow(Pages::RefreshSearchIndexJob).to receive(:perform_later)
    allow(Pages::BatchAnalyzeTopicsJob).to receive(:perform_later)

    described_class.perform_now

    expect(Pages::RefreshSearchIndexJob).to have_received(:perform_later)
    expect(Pages::BatchAnalyzeTopicsJob).to have_received(:perform_later)
  end
end
