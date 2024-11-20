require "rails_helper"

RSpec.describe Pages::BatchEmbeddingJob, type: :job do
  it "doesn’t blow up" do
    FactoryBot.create(:page, :published)
    expect(Pages::EmbeddingJob).to receive(:perform_later).once

    described_class.perform_now
  end

  it "doesn’t blow up when page has embedding" do
    page = FactoryBot.create(:page, :published)
    FactoryBot.create(:page_embedding, id: page.id)

    expect(Pages::EmbeddingJob).not_to receive(:perform_later)

    described_class.perform_now
  end
end
