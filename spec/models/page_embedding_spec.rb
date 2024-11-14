require "rails_helper"

RSpec.describe PageEmbedding, type: :model do
  it "declared openai embedding length" do
    expect(described_class::OPENAI_EMBEDDING_LENGTH).to eq(1536)
  end
end
