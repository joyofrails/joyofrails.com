require "rails_helper"

RSpec.describe Pages::BatchEmbeddingJob, type: :job do
  it "doesn’t blow up" do
    Page.upsert_collection_from_sitepress!(limit: 3)

    described_class.perform_now
  end
end
