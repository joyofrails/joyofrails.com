# frozen_string_literal: true

class PageEmbedding < ApplicationRecord
  attribute :embedding, Types::Vector.new

  belongs_to :page, inverse_of: :page_embedding, foreign_key: :id, primary_key: :id

  scope :similar_to, ->(page_embedding, limit: 11) {
    select("id, distance")
      .where("embedding MATCH ?", page_embedding.embedding.to_s)
      .where("k = ?", limit)
      .order(distance: :asc)
  }

  def self.custom_create(id:, embedding:)
    connection.execute sanitize_sql([<<~SQL.squish, id, embedding.to_s])
      INSERT INTO page_embeddings (id, embedding)
      VALUES (?, ?)
    SQL
  end

  # SQLite supports upserts via INSERT ON CONFLICT DO UPDATE for normal tables
  # but not for virtual tables. This method behaves like an upsert the embedding
  # for a page by first removing the existing embedding if it exists and then
  # creating a new one.
  def self.upsert_embedding!(page, embedding)
    transaction do
      page.page_embedding&.destroy
      custom_create(id: page.id, embedding: embedding)
    end
  end
end
