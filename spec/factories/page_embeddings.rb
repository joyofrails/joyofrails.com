FactoryBot.define do
  sequence(:random_embedding) do
    Array.new(PageEmbedding::OPENAI_EMBEDDING_LENGTH) { rand(-0.1..0.1) }
  end

  factory :page_embedding do
    id { SecureRandom.uuid_v7 }
    embedding { generate(:random_embedding) }
  end
end
