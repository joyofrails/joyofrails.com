# frozen_string_literal: true

class PageEmbedding < ApplicationRecord
  OPENAI_EMBEDDING_LENGTH = 1536

  attribute :embedding, Types::Vector.new

  belongs_to :page, inverse_of: :page_embedding, foreign_key: :id, primary_key: :id, touch: true

  scope :similar_to, ->(page) do
    select(:id, :distance)
      .where("embedding MATCH (?)", PageEmbedding.select(:embedding).where(id: page.id))
  end

  # SQLite supports upserts via INSERT ON CONFLICT DO UPDATE for normal tables
  # but not for virtual tables. This method behaves like an upsert the embedding
  # for a page by first removing the existing embedding if it exists and then
  # creating a new one.
  def self.upsert_embedding!(page, embedding)
    transaction do
      page.page_embedding&.destroy
      create(id: page.id, embedding: embedding)
    end
  end

  def self.random
    Array.new(OPENAI_EMBEDDING_LENGTH) { rand(-0.1..0.1) }
  end
end
