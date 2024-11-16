require "rails_helper"

RSpec.describe Pages::BatchEmbeddingJob, type: :job do
  it "doesn’t blow up" do
    FactoryBot.create(:page, :published)

    described_class.perform_now
  end
end
