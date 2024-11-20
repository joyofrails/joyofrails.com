require "rails_helper"

RSpec.describe PageEmbedding, type: :model do
  it "declared openai embedding length" do
    expect(described_class::OPENAI_EMBEDDING_LENGTH).to eq(1536)
  end

  it "serializes and deserializes embedding vector" do
    embedding = FactoryBot.generate(:random_embedding)
    page = FactoryBot.create(:page)

    page_embedding = PageEmbedding.create!(id: page.id, embedding: embedding)

    expect(page_embedding.embedding).to eq(embedding)

    page_embedding.reload

    expect(page_embedding.embedding.length).to eq(embedding.length)

    # We don't want to compare exact values because of floating point precision
    # issues. Instead, we'll compare the first few values because it’s good
    # enough.
    page_embedding.embedding.take(5).zip(embedding.take(5)).each do |actual, expected|
      expect(actual).to be_within(0.01).of(expected)
    end
  end

  it "upserts embedding for a page" do
    page = FactoryBot.create(:page)

    random_embedding_1 = FactoryBot.generate(:random_embedding)

    page_embedding_1 = PageEmbedding.upsert_embedding!(page, random_embedding_1)

    expect(page_embedding_1.embedding.length).to eq(random_embedding_1.length)
    page_embedding_1.embedding.take(5).zip(random_embedding_1.take(5)).each do |actual, expected|
      expect(actual).to be_within(0.01).of(expected)
    end

    page.reload

    random_embedding_2 = FactoryBot.generate(:random_embedding)

    page_embedding_2 = PageEmbedding.upsert_embedding!(page, random_embedding_2)

    expect(page_embedding_2.embedding.length).to eq(random_embedding_2.length)
    page_embedding_2.embedding.take(5).zip(random_embedding_2.take(5)).each do |actual, expected|
      expect(actual).to be_within(0.01).of(expected)
    end

    expect(PageEmbedding.count).to eq(1)
  end
end
