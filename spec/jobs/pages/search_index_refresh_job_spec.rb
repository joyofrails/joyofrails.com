require "rails_helper"

RSpec.describe Pages::SearchIndexRefreshJob, type: :job do
  it "refreshes the search index" do
    allow(Page).to receive(:refresh_search_index)

    described_class.perform_now

    expect(Page).to have_received(:refresh_search_index)
  end
end
