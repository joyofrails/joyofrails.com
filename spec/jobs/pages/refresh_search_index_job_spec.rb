require "rails_helper"

RSpec.describe Pages::RefreshSearchIndexJob, type: :job do
  it "doesn’t blow up" do
    Page.upsert_collection_from_sitepress!(limit: 2)

    described_class.perform_now
  end
end
